function makePromise () {
    var _status = 'pending';
    var _outcome = null;
    var _waiting = [];
    var _dreading = [];
    function vouch (deed, func) {
      switch (_status) {
        case 'pending':
          (deed === 'fulfilled' ? _waiting : _dreading).push(func);
          break;
        case deed:
          func(_outcome);
          break;
      }
    }
    function resolve (deed, value) {
      if (_status !== 'pending') {
        throw new Error("the promise has already been resolved: " + _status);
      }
      _status = deed;
      _outcome = value;
      (deed === 'fulfilled' ? _waiting : _dreading).forEach(function(func) {
        try {
          func(_outcome);
        } catch (_error) {}
      });
      _waiting = null;
      _dreading = null;
    }

    return {
      then: function(func) {
        vouch('fulfilled', func);
      },

      fail: function(func) {
        vouch('rejected', func);
      },

      fulfill: function(value) {
        resolve('fulfilled', value);
      },

      reject: function(string) {
        resolve('rejected', string);
      },

      status: function() {
        return _status;
      }
    };
  }
