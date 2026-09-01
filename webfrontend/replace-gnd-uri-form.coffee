class ReplaceGNDURIBaseConfig extends BaseConfigPlugin
  getFieldDefFromParm: (baseConfig, pname, def, parent_def) ->
    
    if def.plugin_type != "replace-gnd-uri-form"
      return 
    
    # generate form with datatable
    replaceForm =
      type: CUI.Form
      name: "replace_gnd_uri"
      class: "replace_gnd_uri"
      fields: [
        type: CUI.DataTable
        rowMove: true
        name: "data_table"
        fields: [
          form:
            label: $$("replacegnduriform.data_table.from_gnd_uri")
          type: CUI.Input
          name: "from"
        ,
          form:
            label: $$("replacegnduriform.data_table.to_gnd_uri")
          type: CUI.Input
          name: "to"        
        ]
      ]

    replaceForm

CUI.ready =>
  BaseConfig.registerPlugin(new ReplaceGNDURIBaseConfig())
