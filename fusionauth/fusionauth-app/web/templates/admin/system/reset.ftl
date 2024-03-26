[#ftl/]
[#-- @ftlvariable name="running" type="boolean" --]
[#-- @ftlvariable name="kickstartFiles" type="java.util.List<java.util.UUID>" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/helpers.ftl" as helpers/]

[@layout.html]
  [@layout.head]
  [#if running]
  <script>
    Prime.Document.onReady(function() {
      setTimeout(function() {
        location.reload();
      }, 5000);
    });
  </script>
  [/#if]
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="reset" method="POST"  enctype="multipart/form-data" class="full labels-left" id="reset" includeSave=!running includeCancel=true cancelURI="/admin" saveColor="red" saveKey="confirm" panelClass="orange panel" breadcrumbs={"": "system", "/admin/system/reset": "reset"}]
      <div class="row">
       <div class="col-xs">
         <fieldset>
           <legend><i class="fa fa-exclamation orange-text"></i> Note </legend>
           <p class="mt-0 text-larger">This feature is in tech preview, it is intended to assist you during development. If it breaks, please open a GH issue and let us know. Your uploaded kickstart files may or may not be preserved while this feature is in preview.</p>
         </fieldset>
       </div>
      </div>

      <div class="row">
        <div class="col-xs">
          <p class="pb-3">[@message.print key="confirmMessage"/]</p>
          [@control.select items=kickstartFiles name="kickstartId" textExpr="name" valueExpr="id" headerL10n="selection-required" headerValue="" required=true /]
          [@control.text autofocus="autofocus" name="confirm" autocapitalize="none" autocomplete="off" autocorrect="off" required=true/]
        </div>
      </div>

      <div class="row mt-4">
        <div class="col-xs">
          <fieldset>
          <legend>Upload</legend>
             <p><em>You may upload a <code>kickstart.json</code> file in JSON format, or you may upload a zip file that includes the <code>kickstart.json</code> file in the root of the archive with any includes in relative paths.</em></p>
              <fieldset>
                [@control.file name="kickstart" required=true/]
                [@helpers.customFormRow "foo" "empty" ]
                  [@button.formIcon "save" "blue" "upload" false false "action" "upload"/]
                [/@helpers.customFormRow ]
              </fieldset>
          </fieldset>
          </div>
        </div>

    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]