# Setup the solrCloud in separate machines for distributed indexing and search.

## Deployment
We use `Solr + Zookeeper`, and three CSIL machines(`csil-01, csil-20, csil-03`)to set up the environment, there are following steps:
+ Setup the `zookeeper` node on `csil-01`. 
+ At `<zookeeper_home>/conf`, rename the `zoo_sample.cfg` to `zoo.cfg`, and set the specific location of `dataDir`. Start the `zookeeper` by using `./bin/zkServer.sh` 
+ Setup the solr node on `csil-01`, `csil-20`, `csil-03`. Apply the same following steps on three machines.
+ Copy the default `zoo.cfg` and `solr.xml` from `<solr_home>/server/solr` to `<solr_home>/server/solr/node1/solr/`
+ Start solr by using 
> `<solr_home>./bin/solr start`<br/>
> `-cloud -s <solr_home>/server/solr/node1/solr `<br/>
> `-p 8983 `<br/>
> `-z <Node1 IP>:2181 -m 2g`<br/>
+ Push the solr configuration to `zookeeper`. Since the data set is the same as the single node setting, we just need to put all the configuration files of solr from single node setting to `<solr_home>/server/solr/configsets/solrCloudconfig/conf`. Then push these configurations to `zookeeper` by using
> `<solr_home>./server/scripts/cloud-scripts/zkcli.sh`<br/>
> `-zkhost csil-01-IP:2181 `<br/>
> `-cmd upconfig` <br/>
> `-confname solrCloud` <br/>
> `-confdir <solr_home>/server/solr/configsets/solrCloudconfig/conf`
+ Create a collection, which is composed of three shreds and two replicas on each node.
> `http://csil-01-IP:8983/solr/admin/collections?`<br/>
> `action=CREATE` <br/>
> `&name=solrCloud`<br/>
> `&numShards=3`<br/>
> `&replicationFactor=2`<br/>
> `&maxShardsPerNode=2`<br/>
> `&collection.configName=solrCloudconf`<br/>
+ Go to the http://csil-01-ip:8983/solr and create a new core and specify the solrCloud collection and solrCloudconfig which we just created.
+ Import the data into the new core by using the same URL as the single node, then the solrCloud will automatically create shreds and replicas for you on different machines within the cluster.
