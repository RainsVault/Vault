GetReq = function()
	if((syn)and(syn["request"]))then
		return(syn["request"])
	elseif(http_request)then
		return(http_request)
	elseif(http["request"])then
		return(http["request"])
	elseif((request)or(KRNL)or(KRNL_LOADED))then
		return(request)
	else
		return(error("Executor not Supported."))
	end;
end;
