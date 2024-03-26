[#ftl/]

[#import "_utils/button.ftl" as button/]
[#import "_layouts/user.ftl" as layout/]
[#import "_utils/message.ftl" as message/]
[#import "_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.main columnClass="col-xs col-lg-8"]
      [@panel.full titleKey="panel-title" rowClass="row center-xs" columnClass="col-xs col-lg-8" panelClass="orange panel"]
        <p>
          Maintenance mode on the database and search engine was attempted and failed. Possible reasons why this failed and you ended up here:
        </p>
        <ol>
          <li>Silent configuration was attempted because you enabled silent mode using <code>fusionauth-app.silent-mode=true</code> configuration (or environment variable) and was unable to complete successfully.</li>
          <li>The database is not started, or not accessible using the JDBC URL provided in the <code>database.url</code> configuration (or environment variable).</li>
          <li>The database root credentials provided by <code>database.root-username</code> and optionally <code>database.root-password</code> configurations (or environment variables) were incorrect or did not have adequate privileges to create the schema.</li>
          <li>You are trying to use MySQL but have not yet downloaded and installed the MySQL connector JAR or built a Docker container that includes this JAR.</li>
          <li>Elasticsearch is not started, or not accessible using the URL(s) provided in the <code>search.servers</code> configuration (or environment variable).</li>
          <li>A problem exists between the keyboard and chair (PEBKAC).</li>
        </ol>
        <p>
          Please review the values you specified in the environment variables, ensure the database and Elasticsearch services are accessible and review the FusionAuth logs.
        </p>
        <p>
          If you are not using Elasticsearch and have configured FusionAuth to use the database search engine then the good news is that you will not need the <code>search.servers</code> configuration (or environment variable). The bad news is that the probability that we are looking at a PEBKAC situation has just increased.
        </p>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
