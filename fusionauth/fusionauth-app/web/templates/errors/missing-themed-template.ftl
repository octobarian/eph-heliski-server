[#ftl/]
[#-- @ftlvariable name="theme" type="io.fusionauth.domain.Theme" --]

[#import "../_layouts/user.ftl" as layout/]
[#import "../_utils/button.ftl" as button/]
[#import "../_utils/message.ftl" as message/]
[#import "../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.main]
      [@panel.full titleKey="themed-template-missing-title" rowClass="row center-xs" columnClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4"]
        <p>
        It appears as though you're trying to use a new feature in FusionAuth and that is fantastic!
        </p>

        <p>
        The first thing you'll want to do is update the <strong>${theme.name}</strong> theme so that it contains the necessary templates.
        </p>

        <p>
        Find your way to the FusionAuth Settings and select Themes, there you can edit <strong>${theme.name}</strong> and make the necessary corrections.
        </p>
        <p>
        If you need to bypass your current theme to do so, append <strong>?bypassTheme=true</strong> to the URL.
        </p>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
