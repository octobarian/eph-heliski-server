[#ftl/]
[#-- @ftlvariable name="form" type="io.fusionauth.domain.form.Form" --]
[#-- @ftlvariable name="fields" type="java.util.Map<java.util.UUID, io.fusionauth.domain.form.FormField>" --]
[#-- @ftlvariable name="formTypes" type="io.fusionauth.domain.form.FormType[]" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[#macro formFields action]
  <fieldset>
    [#if action=="add"]
      [@control.text name="formId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}id')/]
    [#else]
      [@control.text name="formId" disabled=true autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}readOnly')/]
    [/#if]
    [@control.text name="form.name" autocapitalize="on" autocomplete="on" autocorrect="on" autofocus="autofocus" required=true tooltip=function.message('{tooltip}displayOnly')/]
    [@control.hidden id="form_type_hidden" name="form.type"/]
    [@control.select name="form.type" items=formTypes tooltip=function.message('{tooltip}readOnly') disabled=true/]
  </fieldset>

  <style>
    #form-step-table > tbody > tr > td > div {
      margin-bottom: 3rem;
    }
  </style>

  <fieldset class="form-row mt-4" >
    <legend id="form-step-table-label"
      data-registration-label="${message.inline("steps")}"
      data-admin-registration-label="${message.inline("sections")}"
      data-admin-user-label="${message.inline("sections")}"
      data-self-service-user-label="${message.inline("sections")}"
      data-registration-add-button-label="${message.inline("add-button-steps")}"
      data-admin-registration-add-button-label="${message.inline("add-button-sections")}"
      data-admin-user-add-button-label="${message.inline("add-button-sections")}"
      data-self-service-user-add-button-label="${message.inline("add-button-sections")}"
      data-registration-step-label="${message.inline("step")}"
      data-admin-registration-step-label="${message.inline("section")}"
      data-admin-user-step-label="${message.inline("section")}"
      data-self-service-user-step-label="${message.inline("section")}"
      data-admin-registration-error="${message.inline("no-sections")}"
      data-admin-user-error="${message.inline("no-sections")}"
      data-registration-error="${message.inline("no-steps")}">
      data-self-service-user-error="${message.inline("no-sections")}"
      [@message.print "steps"/]
    </legend>
    [@message.showFieldErrors "form.steps" /]
    [@message.showFieldErrors "form.steps.fields" /]

    <table id="form-step-table" class="mt-4" data-template="form-step-row-template" data-add-button="form-step-add-button" data-delete-button=".step-delete">
      <thead></thead>
      <tbody>
          <tr class="empty-row">
            <td colspan="1">[@message.print key="no-steps"/]</td>
          </tr>
        [#-- Form Steps --]
       [#list form.steps as step]
        <tr class="step-row">
          <td class="form-row top">
            <label style="margin-top: 0;">
            <span class="form-row-step-label">[@message.print key="step"/] </span>
            <span class="form-row-step-index">${(step?index) + 1}</span>
            <div class="re-orderable ml-2">
              <a href="#" class="button up" data-tooltip="${message.inline("{tooltip}move-up")}"></a>
              <a href="#" class="button down" data-tooltip="${message.inline("{tooltip}move-down")}"></a>
            </div>
            </label>
            <div class="d-inline-block">
            <div class="ml-3">
              <table data-template="form-field-row-template" data-delete-button=".field-delete">
                 <thead class="light-header">
                   <tr>
                     <th class="tight"></th>
                     <th>[@message.print key="name"/]</th>
                     <th>[@message.print key="key"/]</th>
                     <th>[@message.print key="control"/]</th>
                     <th>[@message.print key="type"/]</th>
                     <th>[@message.print key="required"/]</th>
                     <th class="action">[@message.print key="action"/]</th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr class="empty-row">
                     <td colspan="6">[@message.print key="no-fields"/]</td>
                   </tr>
                   [#list (step.fields)![] as fieldId]
                   <tr class="field-row">
                     [@control.hidden name="form.steps[${step?index}].fields[${fieldId?index}]" /]
                     <td>
                        <div class="re-orderable">
                         <a href="#" class="button up" data-tooltip="${message.inline("{tooltip}move-up")}"></a>
                         <a href="#" class="button down" data-tooltip="${message.inline("{tooltip}move-down")}"></a>
                       </div>
                     </td>
                     <td>${properties.display(fields(fieldId), "name")}</td>
                     <td>${properties.display(fields(fieldId), "key")}</td>
                     <td>${properties.display(fields(fieldId), "control")}</td>
                     <td>${properties.display(fields(fieldId), "type")}</td>
                     <td>${properties.displayBoolean(fields(fieldId), "required", false)}</td>
                     <td><a href="#" data-tooltip="Delete" title="Delete" class="small-square red field-delete button"><i class="fa fa-trash"></i></a></td>
                   </tr>
                   [/#list]
                 </tbody>
               </table>
               <div class="mt-5">
                 <a data-add-button href="/ajax/form/field/add" class="blue button"><i class="fa fa-plus"></i> [@message.print key="add-field"/]</a>
               </div>
            </div>
         </div>
         </td>
          <td class="action top"> <a href="#" data-tooltip="Delete" title="Delete" class="small-square red step-delete button"><i class="fa fa-trash"></i></a> </td>
        </tr>
        [/#list]
        </tbody>
      </table>

      [#-- Step Template --]
      <script type="x-handlebars" id="form-step-row-template">
       <tr class="step-row">
       <td class="form-row top">
         <label style="margin-top: 0;">
           <span class="form-row-step-label">[@message.print key="step"/]</span>
           <span class="form-row-step-index">{{increment index}}</span>
           <div class="re-orderable ml-2">
             <a href="#" class="button up" data-tooltip="${message.inline("{tooltip}move-up")}"></a>
             <a href="#" class="button down" data-tooltip="${message.inline("{tooltip}move-down")}"></a>
           </div>
         </label>
         <div class="d-inline-block">
            <div class="ml-3">
              <table data-template="form-field-row-template" data-delete-button=".field-delete">
                 <thead class="light-header">
                   <tr>
                     <th class="tight"></th>
                     <th>[@message.print key="name"/]</th>
                     <th>[@message.print key="key"/]</th>
                     <th>[@message.print key="control"/]</th>
                     <th>[@message.print key="type"/]</th>
                     <th>[@message.print key="required"/]</th>
                     <th class="action">[@message.print key="action"/]</th>
                   </tr>
                 </thead>
                 <tbody> </tbody>
               </table>
               <div class="mt-5">
                 <a data-add-button href="/ajax/form/field/add" class="blue button"><i class="fa fa-plus"></i> [@message.print key="add-field"/]</a>
               </div>
            </div>
         </div>
       </td>
       <td class="action top"> <a href="#" data-tooltip="Delete" title="Delete" class="small-square red step-delete button"><i class="fa fa-trash"></i></a> </td>
       </tr>
      </script>
      [#-- Form Field Template --]
      <script type="x-handlebars" id="form-field-row-template">
       <tr class="field-row">
         <input type="hidden" name="form.steps[{{step}}].fields[{{index}}]" value="{{fieldId}}" />
         <td>
            <div class="re-orderable">
             <a href="#" class="button up" data-tooltip="${message.inline("{tooltip}move-up")}"></a>
             <a href="#" class="button down" data-tooltip="${message.inline("{tooltip}move-down")}"></a>
           </div>
         </td>
         <td>{{fieldName}}</td>
         <td>{{fieldKey}}</td>
         <td>{{cap fieldControl}}</td>
         <td>{{cap fieldType}}</td>
         <td>{{yesNo required}}</td>
         <td><a href="#" data-tooltip="Delete" title="Delete" class="small-square red field-delete button"><i class="fa fa-trash"></i></a></td>
       </tr>
      </script>
     <div class="mt-5">
       <a id="form-step-add-button" href="#" class="blue button "><i class="fa fa-plus"></i> <span>[@message.print key="add-step"/]</span></a>
     </div>
  </fieldset>
[/#macro]