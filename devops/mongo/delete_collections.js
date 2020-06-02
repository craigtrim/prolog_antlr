
collection_substr = '20200116'

db = db.getSiblingDB("cendant")
to_delete = db.getCollectionNames().filter(function(name){return name.includes(collection_substr)})

if (to_delete.length) {
    for (let i = 0; i < to_delete.length; i++) {
        print("Deleting " + db[to_delete[i]] + "...")
        db[to_delete[i]].drop()
    }
} else {
    print("Nothing to delete")
}

