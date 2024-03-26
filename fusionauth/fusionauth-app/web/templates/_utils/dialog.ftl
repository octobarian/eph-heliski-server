[#ftl/]

[#import "button.ftl" as button/]
[#import "message.ftl" as message/]

[#macro basic titleKey="details" includeFooter=true]
  <header data-dialog-role="draggable">
    <h2>[@message.print key=titleKey/] <a href="#" data-dialog-role="close-button"><i class="fa fa-times-circle"></i></a></h2>
  </header>
  <main>
    [#nested/]
  </main>
  [#if includeFooter]
    <footer>
      <a href="#" data-dialog-role="close-button"><strong>[@message.print key="close"/]</strong></a>
    </footer>
  [/#if]
[/#macro]

[#macro confirm action key idField="" titleKey="title" idField2="" idField3="" ajaxSuccessURI="" includeFooter=false]
  [@basic titleKey=titleKey includeFooter=includeFooter]
    [@message.printErrorAlerts/]
    [@message.printInfoAlerts/]
    [#if fieldMessages[idField]??]
      [@message.alert message=fieldMessages[idField][0] type="error" icon="exclamation-circle" includeDismissButton=false/]
    [/#if]
    [#if ajaxSuccessURI != '']
      [#assign ajaxSuccessURI = request.contextPath + ajaxSuccessURI/]
    [/#if]
    [@control.form action=action method="POST" ajax=true ajaxSuccessURI=ajaxSuccessURI class="full"]
      [#nested/]
      <fieldset>
        <p>[@message.print key=key/]</p>
        [#if idField?has_content]
          [@control.hidden name=idField/]
        [/#if]
        [#if idField2?has_content]
          [@control.hidden name=idField2/]
        [/#if]
        [#if idField3?has_content]
          [@control.hidden name=idField3/]
        [/#if]
        [#if tenantId?has_content]
          [@control.hidden name="tenantId"/]
        [/#if]
      </fieldset>
      [@button.formIcon/]
    [/@control.form]
  [/@basic]
[/#macro]

[#macro form action titleKey="title" submitIcon="save" submitColor="blue" submitTextKey="submit" cancelTextKey="cancel" formClass="" id="" disableSubmit=false includeFooter=true]
  [@basic titleKey=titleKey includeFooter=false]
    [@message.printErrorAlerts/]
    [@message.printInfoAlerts/]
    [#if !errorMessages?has_content]
      [@control.form action=action method="POST" ajax=true class=formClass id="${id}"]
        [#nested/]
      [#if includeFooter]
        <footer>
          [@button.formIcon icon=submitIcon color=submitColor textKey=submitTextKey disabled=disableSubmit/]
          [@button.iconLinkWithText href="#" icon="reply" color="gray" textKey=cancelTextKey data_dialog_role="close-button"/]
        </footer>
      [/#if]
      [/@control.form]
    [/#if]
  [/@basic]
[/#macro]

[#-- Wrap our view AJAX templates to handle messaging from a 404 so we don't have to be defensive against null --]
[#macro view titleKey="details" includeFooter=true]
  [@basic titleKey=titleKey includeFooter=includeFooter]
    [#if errorMessages?has_content]
      [@message.printErrorAlerts/]
    [#else]
      [#nested/]
    [/#if]
  [/@basic]
[/#macro]