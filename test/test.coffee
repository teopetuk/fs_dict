module.exports =
    setUp: (callback) ->
                        callback()
    tearDown: (callback) ->
                        callback()

    "morpher":
            "rq": (t)->
                      m = require '../src/morpher'
                      m.word    'простое слово',
                                (e,r)->
                                    console.log JSON.stringify {e,r}
                                    t.done()
