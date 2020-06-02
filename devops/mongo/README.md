# mongoimport/mongoexport

A combination of `mongoexport` and `mongoimport` is used to migrate the data from
`wftag` to cloud.ibm.com. Unfortunately, `mongoimport`'s resilience is terrible,
so it fails very often.

`migrate/export-import.sh`
* gets its mongodb credentials from `ORIGIN_URL` and `TARGET_URL`. Assumes that
  the target mongodb instance used SSL
* gets a list of collections from `ingest.txt`. This file is stored in git. You
  can use `mongo $ORIGIN_URL --eval "db.getCollectionNames()"` to verify that
  it is current
* walks the list of collections and, for each of the
  * `mongoexport`s it to a JSON file in the `migrate/output` folder
  * `mongoimport`s it, without dropping the collection

In my experience, the above script has not been enough. `migrate/split-and-import.sh`
receives as a parameter one of the files in the `migrate/output` folder and
* gets its mongodb credentials from TARGET_URL` and assumes SSL is used.
* derives the collection name from the input file
* splits the file in smaller files, that are placed in `migrate/fragments`
* `mongoinsert`s each of the fragments, retrying forever until all the files
  have been successfully processed and deleted

Both scripts can take several hours to complete.
