path = require 'path'
fs= require 'fs'

defaultFolderSort=
    (a,b)->return if a<b then -1 else 1

defaultFolderFilter=
    (name)->return name.match /\.json$/

defaultConfig =
    basePath: path.join __dirname, "../test"
    collections:[
            descr: "test test"
            property: "words"
            keyProperty: "foo"
            folder: "words"
#            files:["words1.json","words2.json"]
            folderSort: defaultFolderSort
            folderFilter: defaultFolderFilter
    ]

module.exports =

    defaultConfig: defaultConfig

    ###
        delete dictionary files
    ###
    clear: (config, collectionIndex, callback)->
        {basePath,collections} = config
        basePath?=defaultConfig.basePath
        return callback "no collection (#{collectionIndex})" unless collection=collections?[collectionIndex]

        console.log "clear collection (#{collectionIndex}): ",collection.descr
        return callback 'bad collection: folder' if !folder

        {property,keyProperty,folder,files,folderSort,folderFilter} = collection

        rmFiles=
            (files)->
                for file in files
                    filePath = path.join folderPath, file
                    console.log 'deleting ',filePath
                    fs.unlink filePath
                return "ok"

        switch
            when files
                console.log "filesList"
                status=rmFiles files
            when folderPath
                console.log "folder"
                files = fs.readdirSync folderPath
                folderFilter ?= defaultFolderFilter
                files = files.filter folderFilter
                status=rmFiles files
            else
                return callback "no source"
        return callback status if status != "ok"
        callback()


    ###
        constructs dictionary from files using config
    ###
    create: (config, callback)->
        unless callback
            callback = config
            config = defaultConfig

        {basePath,collections} = config
        basePath?=defaultConfig.basePath
        return callback 'no collections' unless collections?.length
        result = {}

        for collection in collections
            {property,keyProperty,folder,files,folderSort,folderFilter} = collection
            console.log collection
            return callback 'bad collection: props' if !property || !keyProperty
            return callback 'bad collection: folder' if !folder

            map = {}
            result[property] ?= map

            folderPath = path.join basePath, folder

            loadFilesList =
                (files)->
                    for file in files
                        filePath = path.join folderPath, file
                        console.log 'loading ',filePath
                        return 'no data' unless data = require filePath
                        console.log "map items: ",data.length
                        for item in data
                            key = "#{item[keyProperty]}"
                            map[key] = item             # override if key exists
                    return "ok"

            loadFolder =
                (folderPath)->
                    files = fs.readdirSync folderPath
                    folderFilter ?= defaultFolderFilter
                    folderSort ?= defaultFolderSort
                    files = files.filter folderFilter
                    files.sort folderSort
                    return loadFilesList files

            switch
                when files
                    console.log "loadFilesList"
                    status = loadFilesList files
                when folderPath
                    console.log "loadFolder"
                    status = loadFolder folderPath
                else
                    return callback "no source for (#{property})"
            return callback status if status != "ok"

        callback null, result