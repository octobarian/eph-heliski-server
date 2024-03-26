[#ftl/]
[#-- @ftlvariable name="running" type="boolean" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.pageForm action="internal-reset" method="POST" id="internal-reset" includeSave=true saveColor="red" includeCancel=true cancelURI="/admin/" breadcrumbs={"": "system", "/admin/system/internal-setup": "page-title"}]
      <div class="row">
        <div class="col-xs">
          <p>
            This is for <span class="red-text md-text"><strong>internal use only</strong></span>. This is a destructive operation and it will erase your database.
            It will delete all users including the current account you are logged in with.
          </p>
          <p>Running this operation will log you out of FusionAuth, and you can then subsequently login using these default credentials:</p>

          <p style="margin-left: 20px;">
            <strong>Email:</strong> admin@fusionauth.io<br/>
            <strong>Password:</strong> password<br/>
          </p>

        </div>
      </div>
      <div class="row">
        <div class="col-xs">

          <p><strong class="red-text md-text">Do Not</strong> submit this form unless you know what you are doing. Please confirm you wish to continue by typing <strong class="red-text">RESET</strong> in the field below in all uppercase.</p>
          [@control.text autofocus="autofocus" name="confirm" autocapitalize="none" autocomplete="off" autocorrect="off" required=true/]
        </div>
      </div>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]