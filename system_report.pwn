

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

Report_Add(playerid, type, text[]) 
{
	for(new i = 0; i < MAX_REPORTS; i++) 
	{
		if(ReportData[i][rExists]) 
		{
			continue;
		}

		ReportData[i][rExists] = 1;
		ReportData[i][rType] = type;
		ReportData[i][rPlayer] = playerid;
		format(ReportData[i][rText], 128, text);

		new output[128];
		switch(type) 
		{
			case REPORT_TYPE_ADMIN: 
			{
				format(output, sizeof output, "REPORT (%d, %s): %s", playerid, ReturnName(playerid, 1, 1), text);		
			}
			case REPORT_TYPE_SOS: 
			{
				format(output, sizeof output, "SOS (%d, %s): %s", playerid, ReturnName(playerid, 1, 1), text);
			}
		}
		Report_SendMessage(i, output);
		return i;
	}
	return -1;
}

Report_SendMessage(reportid, text[]) {
	switch(ReportData[reportid][rType]) 
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
	new count;

    for (new i = 0; i != MAX_REPORTS; i ++)
	{
	    if (ReportData[i][rExists] && ReportData[i][rPlayer] == playerid && ReportData[i][rType] == type)
	    {
	        count++;
		}
	}
	return count;
}

Report_PlayerRecall(playerid, type) 
{
	for (new i = 0; i != MAX_REPORTS; i ++)
	{
	    if (ReportData[i][rExists] && ReportData[i][rPlayer] == playerid && ReportData[i][rType] == type)
	    {
	    	new output[128];
	        format(output, sizeof output, "[%s %d] (%d, %s) Solicitou cobrança no atendimento.", type == REPORT_TYPE_ADMIN ? ("RE") : ("SOS"), i, playerid, ReturnName(playerid, 1));
			Report_SendMessage(i, output);
		}
	}
}

Report_Remove(reportid) {
	ReportData[reportid][rExists] = 0;
	return 1;
}