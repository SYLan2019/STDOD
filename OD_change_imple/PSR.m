function psr = PSR( response )
    maxresponse = max(response(:));
    m = sum(response(:))/numel(response);
    d = std(response(:));
    psr =( (maxresponse - m)/d )^2;    
end