[#ftl/]
[#-- @ftlvariable name="tokenId" type="java.util.UUID" --]
[#import "../../../_utils/dialog.ftl" as dialog/]

[@dialog.confirm action="delete" key=tokenId?has_content?then("are-you-sure-single", "are-you-sure-all") idField="tokenId" idField2="userId"/]