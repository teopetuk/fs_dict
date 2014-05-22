path = require 'path'
fsDict = require '../src/fs_dict'

module.exports =
    setUp: (callback) ->
                        @cfg = JSON.parse JSON.stringify fsDict.defaultConfig
                        @cfg.basePath = path.join __dirname, "../test"
                        callback()
    tearDown: (callback) ->
                        callback()

    "create":
            "from files list": (t)->
                                 @cfg.collections[0].files=["words1.json","words2.json"]
                                 fsDict.create @cfg, (error,result) ->
                                            t.ok !error, error
                                            console.log result
                                            t.ok result?.words["1"].value==3,
                                            t.done()

            "from folder": (t)->
                                 @cfg.collections[0].files=null
                                 @cfg.collections[0].folder="words"
                                 fsDict.create @cfg, (error,result) ->
                                            t.ok !error, error
                                            console.log result
                                            t.ok result?.words["1"].value==3,
                                            t.done()