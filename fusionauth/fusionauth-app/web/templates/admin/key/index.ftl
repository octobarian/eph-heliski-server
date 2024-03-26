[#ftl/]
[#-- @ftlvariable name="keyAlgorithms" type="java.util.List<io.fusionauth.domain.Key.KeyAlgorithm>" --]
[#-- @ftlvariable name="keyTypes" type="java.util.List<io.fusionauth.domain.Key.KeyType>" --]
[#-- @ftlvariable name="results" type="java.util.List<io.fusionauth.domain.Key>" --]
[#-- @ftlvariable name="s" type="io.fusionauth.domain.search.KeySearchCriteria" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/search.ftl" as search/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.Keys();
      const form = Prime.Document.queryById('key-form');
      new FusionAuth.Admin.SearchForm(form, 'io.fusionauth.keys.advancedControls');
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" breadcrumbs={"": "settings", "/admin/key/": "key-master"}]
    <div id="key-actions" class="split-button" data-local-storage-key="keys-split-button">
      <a class="gray button item" href="#"><i class="fa fa-spinner fa-pulse"></i> [@message.print key="loading"/]</a>
      <button type="button" class="gray button square" aria-haspopup="true" aria-expanded="false">
        <span class="sr-only">[@message.print key="toggle-dropdown"/]</span>
      </button>
      <div class="menu">

        [#-- Import --]
        <a id="import-public" class="item" href="/ajax/key/import?t=public">
          <i class="green-text fa fa-upload"></i>  <span>[@message.print key="import-public"/]</span>
        </a>
        <a id="import-certificate" class="item" href="/ajax/key/import?t=certificate">
          <i class="green-text fa fa-upload"></i> <span>[@message.print key="import-certificate"/]</span>
        </a>
        <a id="import-certificate-rsa-pair" class="item" href="/ajax/key/import?t=certificate-rsa-pair">
          <i class="green-text fa fa-upload"></i> <span>[@message.print key="import-certificate-rsa-pair"/]</span>
        </a>
        <a id="import-certificate-ec-pair" class="item" href="/ajax/key/import?t=certificate-ec-pair">
          <i class="green-text fa fa-upload"></i> <span>[@message.print key="import-certificate-ec-pair"/]</span>
        </a>
        <a id="import-rsa" class="item" href="/ajax/key/import?t=rsa-pair">
          <i class="green-text fa fa-upload"></i> <span>[@message.print key="import-rsa"/]</span>
        </a>
        <a id="import-ec" class="item" href="/ajax/key/import?t=ec-pair">
          <i class="green-text fa fa-upload"></i> <span>[@message.print key="import-ec"/]</span>
        </a>
        <a id="import-hmac" class="item" href="/ajax/key/import?t=rsa-private">
          <i class="green-text fa fa-upload"></i> <span>[@message.print key="import-rsa-private"/]</span>
        </a>
        <a id="import-hmac" class="item" href="/ajax/key/import?t=ec-private">
          <i class="green-text fa fa-upload"></i> <span>[@message.print key="import-ec-private"/]</span>
        </a>
        <a id="import-hmac" class="item" href="/ajax/key/import?t=hmac">
          <i class="green-text fa fa-upload"></i> <span>[@message.print key="import-hmac"/]</span>
        </a>

        [#-- Generate --]
        <a id="generate-rsa" class="item" href="/ajax/key/generate/RSA">
          <i class="blue-text fa fa-refresh"></i> <span>[@message.print key="generate-rsa"/]</span>
        </a>
        <a id="generate-ec" class="item default" href="/ajax/key/generate/EC">
          <i class="blue-text fa fa-refresh"></i><span> [@message.print key="generate-ec"/]</span>
        </a>
        <a id="generate-hmac" class="item" href="/ajax/key/generate/HMAC">
          <i class="blue-text fa fa-refresh"></i> <span>[@message.print key="generate-hmac"/]</span>
        </a>
      </div>
    </div>
    [/@layout.pageHeader]

    [@layout.main]
      [@panel.full]
        [@control.form id="key-form" action="${request.contextPath}/admin/key/" method="GET" class="labels-above full push-bottom" searchResults="key-content"]
          [@control.hidden name="s.numberOfResults"/]
          [@control.hidden name="s.startRow" value="0"/]

          <div class="row">
            <div class="col-xs-12 col-md-12 tight-left">
              <div class="form-row">
                [@control.text name="s.name" autocapitalize="none" autocomplete="on" autocorrect="off" spellcheck="false" autofocus="autofocus"  placeholder="${function.message('{placeholder}s.name')}"/]
              </div>
            </div>
          </div>

          [#-- Advanced Search Controls --]
          <div id="advanced-search-controls" class="slide-open">
            <div class="row">
                <div class="col-xs-12 col-md-6 tight-left">
                  [@control.select name="s.type" labelKey="type" items=keyTypes headerL10n="any" headerValue="" /]
                </div>
                <div class="col-xs-12 col-md-6">
                  [@control.select name="s.algorithm" labelKey="algorithm" items=keyAlgorithms headerL10n="any" headerValue="" /]
                </div>
            </div>
          </div>

          <a href="#" class="slide-open-toggle" data-expand-open="advanced-search-controls">
            <span>[@message.print key="advanced"/] <i class="fa fa-angle-down"></i></span>
          </a>

          <div class="row push-lesser-top push-bottom">
            <div class="col-xs tight-left">
              [@button.formIcon color="blue" icon="search" textKey="search"/]
              [@button.iconLinkWithText href="/admin/key/?clear=true" color="blue" icon="undo" textKey="reset" class="reset-button" name='reset'/]
            </div>
          </div>
        [/@control.form]

        <div id="key-content">
          [@search.pagination/]
          <div class="scrollable horizontal">
            <table class="hover listing" data-sortable="false">
              <thead>
                <tr>
                  [@helpers.tableHeader "id" "hide-on-mobile"/]
                  [@helpers.tableHeader "name"/]
                  [@helpers.tableHeader "type" "hide-on-mobile"/]
                  [@helpers.tableHeader "algorithm"/]
                  [@helpers.tableHeader "expiration" "hide-on-mobile"/]
                  <th data-sortable="false" class="action">[@message.print key="action"/]</th>
                </tr>
              </thead>
              <tbody>
                [#list results![] as key]
                  [#assign shadowKey = fusionAuth.statics['io.fusionauth.api.service.system.KeyService'].ClientSecretShadowKeys.contains(key.id)/]
                  <tr>
                    <td class="hide-on-mobile">${properties.display(key, "id")}</td>
                    <td>${properties.display(key, "name")}</td>
                    <td class="hide-on-mobile">[@message.print key=key.type.name()/]</td>
                    <td>${properties.display(key, "algorithm")}</td>
                    <td class="hide-on-mobile">${properties.displayZonedDateTime(key, "expirationInstant", "date-format", true)}</td>
                    <td class="action">
                      [#if !shadowKey]
                        [@button.action href="edit/${key.id}" icon="edit" key="edit" color="blue"/]
                      [/#if]
                      [@button.action href="/ajax/key/view/${key.id}" icon="search" key="view" ajaxView=true ajaxWideDialog=true color="green" resizeDialog=true/]
                      [#-- Show the download button for EC or RSA keys that have a public key of some sort. --]
                      [#if key.type != "HMAC" && (key.publicKey?? || key.certificate??)]
                      [@button.action href="/admin/key/download/${key.id}" icon="download" key="download" color="purple"/]
                      [/#if]
                      [#if !shadowKey]
                      [@button.action href="/ajax/key/delete/${key.id}" icon="trash" key="delete" ajaxForm=true color="red"/]
                      [/#if]
                    </td>
                  </tr>
                [#else]
                  <tr>
                    <td colspan="6">[@message.print key="no-results"/]</td>
                  </tr>
                [/#list]
              </tbody>
            </table>
          </div>
          [#if numberOfPages gt 1]
            [@search.pagination/]
          [/#if]
        </div>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
