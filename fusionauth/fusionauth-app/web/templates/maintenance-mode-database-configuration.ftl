[#ftl/]
[#-- @ftlvariable name="database" type="com.inversoft.maintenance.action.MaintenanceModeDatabaseConfigurationAction.DatabaseConfiguration" --]
[#-- @ftlvariable name="mysqlDriverExists" type="boolean" --]

[#import "_utils/button.ftl" as button/]
[#import "_layouts/user.ftl" as layout/]
[#import "_utils/message.ftl" as message/]
[#import "_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head]
    <script type="application/javascript" src="/js/MaintenanceMode-0.1.0.js"></script>
  [/@layout.head]
  [@layout.body]
    [@layout.main columnClass="col-xs col-lg-8"]

      [@panel.full titleKey="page-title" rowClass="row center-xs" columnClass="col-xs col-lg-8"]
        [@control.form action="maintenance-mode-database-configuration" method="POST" class="labels-left full"]
          <fieldset>
            [#if !mysqlDriverExists]
              <div id="mysql-warning" class="alert warning">
                <div class="body">
                  <p>
                    <strong>WARNING!</strong>
                  </p>
                  [@message.print key="[mysql-missing-information]"/]
                </div>
              </div>
            [/#if]
            <legend>[@message.print key="database.dbType"/]</legend>
            <p>[@message.print key="intro"/]</p>
            [@control.radio_list items=["postgresql", "mysql"] name="database.dbType"/]
            [@control.text name="database.host" autocapitalize="none" autocomplete="on" autocorrect="off" autofocus="autofocus" spellcheck="false" required=true/]
            [@control.text name="database.port" autocapitalize="none" autocomplete="on" autocorrect="off" required=true tooltip=function.message('{tooltip}database.port')/]
            [@control.text name="database.database" autocapitalize="none" autocomplete="on" autocorrect="off" spellcheck="false" required=true/]
            [@control.checkbox name="database.ssl" uncheckedValue="false" value="true"/]
          </fieldset>

          <fieldset>
            <legend>[@message.print key="heading.root-credentials"/]</legend>
            <p>
              [@message.print key="intro.root-credentials"/]
            </p>
            [@control.text name="rootUsername" autocapitalize="none" autocomplete="off" autocorrect="off" spellcheck="false"/]
            [@control.text name="rootPassword" autocapitalize="none" autocomplete="off" autocorrect="off" spellcheck="false"/]
          </fieldset>

          <fieldset>
            <legend>[@message.print key="heading.schema-credentials"/]</legend>
            <p>
              [@message.print key="intro.schema-credentials"/]
            </p>
            [@control.text name="database.username" autocapitalize="none" autocomplete="off" autocorrect="off" spellcheck="false" required=true/]
            [@control.text name="database.password" autocapitalize="none" autocomplete="off" autocorrect="off" spellcheck="false" required=true/]
          </fieldset>
          [@button.formIcon/]
        [/@control.form]
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
