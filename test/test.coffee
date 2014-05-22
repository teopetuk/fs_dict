path = require 'path'
fs = require 'fs'
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

    "clear":
            "from files list":(t)->
                                 fname = path.join @cfg.basePath, "words/tmp.tmp"
                                 @cfg.collections[0].files=["tmp.tmp"]
                                 fs.appendFileSync fname,'tmp data'
                                 fsDict.clear @cfg, 0, (error,result) ->
                                            t.ok !error, error
                                            console.log result
                                            t.done()
            "from folder": (t)->
                                 @cfg.collections[0].files=null
                                 @cfg.collections[0].folder="words"
                                 fname = path.join @cfg.basePath, "words/tmp.tmp"
                                 @cfg.collections[0].folderFilter=
                                    (name) -> return name.match /\.tmp/
                                 fs.appendFileSync fname,'tmp data'
                                 fsDict.clear @cfg, 0, (error,result) ->
                                            t.ok !error, error
                                            console.log result
                                            t.done()
