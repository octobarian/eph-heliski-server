[#ftl/]
[#import "../../_utils/dialog.ftl" as dialog/]

[@dialog.form action="${request.contextPath}/ajax/user/comment" formClass="full"]
<fieldset>
  [@control.hidden name="userId"/]
  [@control.textarea name="userComment.comment" autocapitalize="on" autocomplete="on" autocorrect="on" autofocus="autofocus" required=true rows=4 class="textarea resize vertical"/]
</fieldset>
[/@dialog.form]

