CMD:meajude(playerid, params[])
{
	if (isnull(params))
	{
	    SendSyntaxMessage(playerid, "/meajude [motivo]");
	    return 1;
	}
	
	if (Report_GetCount(playerid, REPORT_TYPE_SOS) > 0) 
	{
		SetPVarInt(playerid, "recall_type", REPORT_TYPE_SOS);
		Dialog_Show(playerid, SendRecall, DIALOG_STYLE_MSGBOX, "Reall", "{FFFFFF}Você já tem um SOS em aberto. \nDeseja notificar o admin sobre demora no atendimento?", "Sim", "Cancelar");
		return 1;
	}
	
	if (Report_Add(playerid, REPORT_TYPE_SOS, params) != -1)
	{
		ShowPlayerFooter(playerid, "Seu ~g~SOS~w~ foi enviado!");
		SendServerMessage(playerid, "Seu SOS está sendo avaliado pelos testers online.");
	} 
	else
	{
	    SendErrorMessage(playerid, "A lista de SOS em espera está lotada, aguarde e tente enviar novamente em alguns minutos.");
	}
	return 1;
}

CMD:aa(playerid, params[])
{
	if (!PlayerData[playerid][pTester])
	    return SendErrorMessage(playerid, "Você não é um tester.");

	if (!PlayerData[playerid][pTesterDuty])
	    return SendErrorMessage(playerid, "Você precisa estar em trabalho como tester para usar este comando.");

	new
		userid = strval(params);

	if(!Report_GetCount(userid, REPORT_TYPE_SOS))
	    return SendErrorMessage(playerid, "Sos inválido.");

	Report_Handle(playerid, userid, REPORT_TYPE_SOS);	
	return 1;
}

CMD:ra(playerid, params[])
{
	if (!PlayerData[playerid][pTester])
	    return SendErrorMessage(playerid, "Você não é um tester.");

	if (!PlayerData[playerid][pTesterDuty])
	    return SendErrorMessage(playerid, "Você precisa estar em trabalho como tester para usar este comando.");

	new
		userid = strval(params);

	if(!Report_GetCount(userid, REPORT_TYPE_SOS))
	    return SendErrorMessage(playerid, "Sos inválido.");

	Report_Deny(playerid, userid, REPORT_TYPE_SOS);	
	return 1;
}

CMD:listasos(playerid, params[])
{
	if (!PlayerData[playerid][pTester])
	    return SendErrorMessage(playerid, "Você não é um tester.");

	if (!PlayerData[playerid][pTesterDuty])
	    return SendErrorMessage(playerid, "Você precisa estar em trabalho como tester para usar este comando.");

	new output[128], count = 0;
	for(new i = 0; i != MAX_PLAYERS; i++) {
		if(!Report_GetCount(i, REPORT_TYPE_SOS)) continue;

		GetPVarString(i, "a_sos_text", output, sizeof output);
		format(output, sizeof output, "SOS (%d, %s): %s (%d minutos)", i, ReturnName(i, 1, 1), output, (gettime() - GetPVarInt(i, "a_sos_created")) / 60);	
		SendClientMessage(playerid, COLOR_CYAN, output);
		count++;
	}

	if (!count)
	    return SendErrorMessage(playerid, "Não há nenhum report ativo para mostrar.");

	SendServerMessage(playerid, "Use \"/aa RID\" or \"/ra RID\" para aceitar ou recusar um report.");
	return 1;
}

CMD:listareport(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "Você não pode usar este comando.");

	new output[128], count = 0;
	for(new i = 0; i != MAX_PLAYERS; i++) {
		if(!Report_GetCount(i, REPORT_TYPE_ADMIN)) continue;

		GetPVarString(i, "a_report_text", output, sizeof output);
		format(output, sizeof output, "RE (%d, %s): %s (%d minutos)", i, ReturnName(i, 1, 1), output, (gettime() - GetPVarInt(i, "a_report_created")) / 60);	
		SendClientMessage(playerid, COLOR_LIGHTRED, output);
		count++;
	}

	if (!count)
	    return SendErrorMessage(playerid, "Não há nenhum report ativo para mostrar.");


	SendServerMessage(playerid, "Use \"/ar RID\" or \"/rr RID\" para aceitar ou recusar um report.");
	return 1;
}

CMD:reportar(playerid, params[])
{
	if (isnull(params))
	{
	    SendSyntaxMessage(playerid, "/meajude [motivo]");
	    return 1;
	}
	
	if (Report_GetCount(playerid, REPORT_TYPE_ADMIN) > 0) 
	{
		SetPVarInt(playerid, "recall_type", REPORT_TYPE_ADMIN);
		Dialog_Show(playerid, SendRecall, DIALOG_STYLE_MSGBOX, "Reall", "{FFFFFF}Você já tem um report em aberto. \nDeseja notificar o admin sobre demora no atendimento?", "Sim", "Cancelar");
		return 1;
	}

	SetPVarString(playerid, "report_text", params);
	SetPVarInt(playerid, "report_type", REPORT_TYPE_ADMIN);
	
	new string[490];
	format(string, sizeof string, "{C0C0C0}Você está prestes a enviar o seguinte report:{FFFFFF}\n\t%s\n\n{C0C0C0}Saiba que este comando serve APENAS para reportar algum jogador que está quebrando as regras \nou sobre algum problema que NECESSITE a atenção de algum admin. \nPara os demais problemas, favor usar o /meajude.\nA falha no cumprimento do escrito acima poderá acarretar em punição severa para o jogador.\n\n{F5DEB3}Você será atendido em breve.", params);
	Dialog_Show(playerid, SendReport, DIALOG_STYLE_MSGBOX, "Confirmação de report", string, "Eu Confirmo", "Cancelar");
	return 1;
}

CMD:ar(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "Você não pode usar este comando.");
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/ar [playerid (/listareport para a lista)");

	new
		userid = strval(params);

	if(!Report_GetCount(userid, REPORT_TYPE_ADMIN))
	    return SendErrorMessage(playerid, "Report inválido.");

	Report_Handle(playerid, userid, REPORT_TYPE_ADMIN);	
	return 1;
}

CMD:rr(playerid, params[])
{
	if (PlayerData[playerid][pAdmin] < 1)
	    return SendErrorMessage(playerid, "Você não pode usar este comando.");
	if (isnull(params))
	    return SendSyntaxMessage(playerid, "/rr [playerid] (/listareport para a lista)");

	new
		userid = strval(params);

	if(!Report_GetCount(userid, REPORT_TYPE_ADMIN))
	    return SendErrorMessage(playerid, "Report inválido.");

	Report_Handle(playerid, userid, REPORT_TYPE_ADMIN);	
	return 1;
}

Dialog:SendReport(playerid, response, listitem, inputtext[]) 
{
	if(GetPVarType(playerid, "report_type") == PLAYER_VARTYPE_NONE) {
		return 0;
	}
	if(!response) {
		SendClientMessage(playerid, COLOR_LIGHTRED, "Você cancelou o envio do report!");
		return 1;
	}

	new params[128];
	GetPVarString(playerid, "report_text", params, sizeof params);

	if(GetPVarInt(playerid, "report_type") == REPORT_TYPE_ADMIN)
	{
		if (Report_Add(playerid, REPORT_TYPE_ADMIN, params) != -1)
		{
			ShowPlayerFooter(playerid, "Seu ~g~report~w~ foi enviado!");
			SendServerMessage(playerid, "Seu report está sendo avaliado pelos administradores online.");
		} 
		else
		{
		    SendErrorMessage(playerid, "A lista de reports em espera está lotada, aguarde e tente enviar novamente em alguns minutos.");
		}
	} 

	DeletePVar(playerid, "report_text");
	DeletePVar(playerid, "report_type");
	return 1;
}


Dialog:SendRecall(playerid, response, listitem, inputtext[]) 
{
	if(GetPVarType(playerid, "recall_type") == PLAYER_VARTYPE_NONE) {
		return 0;
	}
	if(!response) {
		SendClientMessage(playerid, COLOR_LIGHTRED, "Você cancelou a solicitação do RECALL.");
		return 1;
	}

	Report_PlayerRecall(playerid, GetPVarInt(playerid, "recall_type"));
	DeletePVar(playerid, "recall_type");
	return 1;
}

Report_Handle(playerid, userid, type) {
	new string[128];

	format(string, sizeof(string), "Voce ~g~aceitou~w~ o sos/report de %s.", ReturnName(userid, 0, 1));
	ShowPlayerFooter(playerid, string);

	if(type == REPORT_TYPE_SOS) {
		SendAdminAction(userid, "%s aceitou seu pedido de ajuda e estará cuidando do caso.", PlayerData[playerid][pAdminName]);
		SendTesterMessage(COLOR_CYAN, "[ADMIN]: %s aceitou o sos de %s (%d minutos)", PlayerData[playerid][pAdminName], ReturnName(userid, 0, 1), (gettime() - GetPVarInt(userid, "a_sos_created")) / 60);

		GetPVarString(userid, "a_sos_text", string, sizeof string);
		SendClientMessage(playerid, -1, string);

		Report_Remove(userid, type);
	} else if(type == REPORT_TYPE_ADMIN) {
		SendAdminAction(userid, "%s aceitou seu report e estará cuidando do caso.", PlayerData[playerid][pAdminName]);
		SendAdminAlert(COLOR_LIGHTYELLOW, "[ADMIN]: %s aceitou o report de %s (%d minutos)", PlayerData[playerid][pAdminName], ReturnName(userid, 0, 1), (gettime() - GetPVarInt(userid, "a_report_created")) / 60);

		GetPVarString(userid, "a_report_text", string, sizeof string);
		SendClientMessage(playerid, -1, string);

		Report_Remove(userid, type);		
	}
	return 1;
}

Report_Deny(playerid, userid, type) {
	new string[128];

	format(string, sizeof(string), "Voce ~g~negou~w~ o sos/report de %s.", ReturnName(userid, 0, 1));
	ShowPlayerFooter(playerid, string);

	if(type == REPORT_TYPE_SOS) {
		SendAdminAction(userid, "%s negou seu pedido de ajuda.", PlayerData[playerid][pAdminName]);
		SendTesterMessage(COLOR_CYAN, "[ADMIN]: %s negou o sos de %s (%d minutos)", PlayerData[playerid][pAdminName], ReturnName(userid, 0, 1), (gettime() - GetPVarInt(userid, "a_sos_created")) / 60);

		Report_Remove(userid, type);
	} else if(type == REPORT_TYPE_ADMIN) {
		SendAdminAction(userid, "%s negou seu report.", PlayerData[playerid][pAdminName]);
		SendAdminAlert(COLOR_LIGHTYELLOW, "[ADMIN]: %s negou o report de %s (%d minutos)", PlayerData[playerid][pAdminName], ReturnName(userid, 0, 1), (gettime() - GetPVarInt(userid, "a_report_created")) / 60);

		Report_Remove(userid, type);		
	}
	return 1;
}

Report_SendMessage(type, text[]) {
	switch(type) 
	{
		case REPORT_TYPE_ADMIN: 
		{
			foreach (new j : Player)
			{
				if (PlayerData[j][pAdmin] > 0) 
				{
					SendClientMessageEx(j, COLOR_LIGHTYELLOW, text);
				}
			}
		}
		case REPORT_TYPE_SOS: 
		{
			SendTesterMessage(COLOR_CYAN, text);
		}
	}
}

Report_GetCount(playerid, type)
{
	switch(type) 
	{
		case REPORT_TYPE_ADMIN: 
		{
			return GetPVarInt(playerid, "a_report_active");
		}
		case REPORT_TYPE_SOS: 
		{
			return GetPVarInt(playerid, "a_sos_active");
		}
	}
	return 1;
}

Report_Add(playerid, type, text[]) 
{
	new output[128];
	switch(type) 
	{
		case REPORT_TYPE_ADMIN: 
		{
			SetPVarInt(playerid, "a_report_active", 1);
			SetPVarString(playerid, "a_report_text", text);
			SetPVarInt(playerid, "a_report_created", gettime());

			format(output, sizeof output, "REPORT (%d, %s): %s", playerid, ReturnName(playerid, 1, 1), text);		
		}
		case REPORT_TYPE_SOS: 
		{
			SetPVarInt(playerid, "a_sos_active", 1);
			SetPVarString(playerid, "a_sos_text", text);
			SetPVarInt(playerid, "a_sos_created", gettime());

			format(output, sizeof output, "SOS (%d, %s): %s", playerid, ReturnName(playerid, 1, 1), text);
		}
	}
	Report_SendMessage(type, output);
	return 1;
}

Report_Remove(playerid, type) {
	switch(type) 
	{
		case REPORT_TYPE_ADMIN: 
		{
			DeletePVar(playerid, "a_report_active");
			DeletePVar(playerid, "a_report_text");
			DeletePVar(playerid, "a_report_created");
		}
		case REPORT_TYPE_SOS: 
		{
			DeletePVar(playerid, "a_sos_active");
			DeletePVar(playerid, "a_sos_text");
			DeletePVar(playerid, "a_sos_created");
		}
	}
	return 1;
}

Report_PlayerRecall(playerid, type) 
{
	new output[128];
    format(output, sizeof output, "[%s] (%d, %s) Solicitou cobrança no atendimento.", type == REPORT_TYPE_ADMIN ? ("RE") : ("SOS"), playerid, ReturnName(playerid, 1, 1));
	Report_SendMessage(type, output);
}