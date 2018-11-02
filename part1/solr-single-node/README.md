# Setup the Solr search engine environment for single node indexing and query.

# Off-line pre-processing data
The originally `TREC Disk 4-5 data file(.xml)` doesn’t strictly comply with the standard XML file format. We leveraged the python script to help data processing. Including
+ Add the beginning tag `<data>`, and the end tag `</data>`.
+ Using the regular expression of python to match and remove the non-standard the XML tag, which may cause the XML parser to fail to process in solr.

## Solr deployment
+ Download and unzip the install package of `solr-7.5.0` search engine.
+ Start the solr by using the command bin/solr start under the `<solr_home>` directory
+ Create the solr core for indexing and querying data, using the command `bin/solr create -c` trec where the trec is the name of the core.
+ Inside the core trec directory(`<solr_home>/server/solr/trec`), we will go to the `conf/` file to change some configuration for the trec core, including 
> + In the `solrconfig.xml` file, add the dataimport handler
> + Create the `data-config.xml` file to indicate the location of the data file and the schema of the extracting information from the data source.
> + Add the corresponding fields data type and attributes to `managed-schema`.
> + After finishing all the above configuration of the trec core, restart the solr by using `bin/solr restart`.
> + Open the browser and go to `localhost:8983/solr` and using select the core `trec` from the scroll list, and select the data import bar and select `full-import`, the solr will start to index the data.
> + After data is finished imported, go to the query page and start the query by typing the keyword for search in whole text or search in certain fields.
> + Checkout the high light box to highlight the words in the text that match the query.