loadAsset = (url) ->
    request = new XMLHttpRequest()
    response = null
    promise = makePromise()

    request.open 'GET', url, false
    request.send null

    if request.status is 200
        promise.fulfill request.responseText
    
    # return
    promise


makePromise = () ->
    status = 'unresolved'
    outcome = null
    waiting = []
    dreading = []

    vouch (deed, func) ->
        switch status
            when 'unresolved' then (if deed is 'fulfilled' then waiting else dreading).push(func)
            when deed then func(outcome)
        
    resolve (deed, value) ->
        if status isnt 'unresolved'
            throw new Error "the promise has already been resolved: #{status}"
        
        status = deed
        outcome = value
        (if deed is 'fulfilled' then waiting else dreading).forEach (func) ->
            try
                func outcome
            catch ignore
        
        waiting = null
        dreading = null
    
    {
        when: (func) -> vouch 'fulfilled', func
        
        fail: (func) -> vouch 'failed', func
        
        fulfill: (value) -> resolve 'fulfilled', value

        smash: (string) -> resolve 'smashed', string
        
        status: () -> status
    }
                
            
        