class GNDUtil
    
  # from https://github.com/programmfabrik/coffeescript-ui/blob/fde25089327791d9aca540567bfa511e64958611/src/base/util.coffee#L506
  # has to be reused here, because cui not be used in updater
  @isEqual: (x, y, debug) ->
    #// if both are function
    if x instanceof Function
      if y instanceof Function
        return x.toString() == y.toString()
      return false

    if x == null or x == undefined or y == null or y == undefined
      return x == y

    if x == y or x.valueOf() == y.valueOf()
      return true

    # if one of them is date, they must had equal valueOf
    if x instanceof Date
      return false

    if y instanceof Date
      return false

    # if they are not function or strictly equal, they both need to be Objects
    if not (x instanceof Object)
      return false

    if not (y instanceof Object)
      return false

    p = Object.keys(x)
    if Object.keys(y).every( (i) -> return p.indexOf(i) != -1 )
      return p.every((i) =>
        eq = @isEqual(x[i], y[i], debug)
        if not eq
          if debug
            console.debug("X: ",x)
            console.debug("Differs to Y:", y)
            console.debug("Key differs: ", i)
            console.debug("Value X:", x[i])
            console.debug("Value Y:", y[i])
          return false
        else
          return true
      )
    else
      return false

    
  @getFullTextFromEntityFactsJSON: (efJSON, pluginConfig) ->
    _fulltext = ''

    # ++
    _fulltext += efJSON['id'] + ' '

    # ++
    _fulltext = efJSON['gndIdentifier'] + ' '

    # ++
    _fulltext += efJSON['preferredName'] + ' '
  
    if not pluginConfig?.fulltext_gnd
      return _fulltext

    fulltextConfig = pluginConfig.fulltext_gnd

    # ++
    if efJSON?.oldAuthorityNumber and fulltextConfig?.oldAuthorityNumber 
      for entry in efJSON.oldAuthorityNumber
        _fulltext += entry + ' '

    # ++
    if efJSON?.gndSubjectCategory and fulltextConfig?.gndSubjectCategory
      for entry in efJSON.gndSubjectCategory
        if entry.preferredName
          _fulltext += entry.preferredName + ' '

    # ++
    if efJSON?.variantName and fulltextConfig?.variantName
      for entry in efJSON.variantName
        _fulltext += entry + ' '

    # ++
    if efJSON?.biographicalOrHistoricalInformation and fulltextConfig?.biographicalOrHistoricalInformation
      for entry in efJSON.biographicalOrHistoricalInformation
        _fulltext += entry + ' '

    # ++
    if efJSON?.dateOfEstablishment and fulltextConfig?.dateOfEstablishment
      for entry in efJSON.dateOfEstablishment
        _fulltext += entry + ' '

    # ++
    if efJSON?.dateOfPublication and fulltextConfig?.dateOfPublication
      for entry in efJSON.dateOfPublication
        _fulltext += entry + ' '

    # ++
    if efJSON?.dateOfBirth and fulltextConfig?.dateOfBirth
      _fulltext += efJSON.dateOfBirth + ' '

    if efJSON?.dateOfProduction and fulltextConfig?.dateOfProduction
      _fulltext += efJSON.dateOfProduction + ' '

    # ++
    if efJSON?.dateOfDeath and fulltextConfig?.dateOfDeath
      _fulltext += efJSON.dateOfDeath + ' '

    # + checked
    if efJSON?.dateOfTermination and fulltextConfig?.dateOfTermination
      _fulltext += efJSON.dateOfTermination + ' '

    # ++
    if efJSON?.author and fulltextConfig?.author
      for entry in efJSON.author
        if entry.preferredName
          _fulltext += entry.preferredName + ' '

    # ++
    if efJSON?.firstAuthor and fulltextConfig?.firstAuthor
      for entry in efJSON.firstAuthor
        if entry.preferredName
          _fulltext += entry.preferredName + ' '

    #
    if efJSON?.organizerOrHost and fulltextConfig?.organizerOrHost
      for entry in efJSON.organizerOrHost
        if entry.preferredName
          _fulltext += entry.preferredName + ' '

    # ++
    if efJSON?.gender and fulltextConfig?.gender
      for entry in efJSON.gender
        if entry.label
          _fulltext += entry.label + ' '

    #
    if efJSON?.placeOfEvent and fulltextConfig?.placeOfEvent
      for entry in efJSON.placeOfEvent
        if entry.preferredName
          _fulltext += entry.preferredName + ' '

    # ++
    if efJSON?.placeOfBirth and fulltextConfig?.placeOfBirth
      for entry in efJSON.placeOfBirth
        if entry.preferredName
          _fulltext += entry.preferredName + ' '

    # ++
    if efJSON?.placeOfDeath and fulltextConfig?.placeOfDeath
      for entry in efJSON.placeOfDeath
        if entry.preferredName
          _fulltext += entry.preferredName + ' '

    # ++
    if efJSON?.placeOfBusiness and fulltextConfig?.placeOfBusiness
      for entry in efJSON.placeOfBusiness
        if entry.preferredName
          _fulltext += entry.preferredName + ' '

    if efJSON?.associatedPlace and fulltextConfig?.associatedPlace
      for entry in efJSON.associatedPlace
        if entry.preferredName
          _fulltext += entry.preferredName + ' '

    # ++
    if efJSON?.topic and fulltextConfig?.topic
      for entry in efJSON.topic
        if entry.label
          _fulltext += entry.label + ' '

    if efJSON?.predecessor and fulltextConfig?.predecessor
      for entry in efJSON.predecessor
        if entry.preferredName
          _fulltext += entry.preferredName + ' '

    # ++
    if efJSON?.precedingCorporateBody and fulltextConfig?.precedingCorporateBody
      for entry in efJSON.precedingCorporateBody
        if entry.preferredName
          _fulltext += entry.preferredName + ' '

    if efJSON?.isA and fulltextConfig?.isA
      for entry in efJSON.isA
        if entry.preferredName
          _fulltext += entry.preferredName + ' '

    # ++
    if efJSON?.composer and fulltextConfig?.composer
      for entry in efJSON.composer
        if entry.preferredName
          _fulltext += entry.preferredName + ' '

    # ++
    if efJSON?.relatedWork and fulltextConfig?.relatedWork
      for entry in efJSON.relatedWork
        if entry.preferredName
          _fulltext += entry.preferredName + ' '

    # ++
    if efJSON?.relatedPerson and fulltextConfig?.relatedPerson
      for entry in efJSON.relatedPerson
        if entry.preferredName
          _fulltext += entry.preferredName + ' '

    # ++
    if efJSON?.precedingPlaceOrGeographicName and fulltextConfig?.precedingPlaceOrGeographicName
      for entry in efJSON.precedingPlaceOrGeographicName
        if entry.preferredName
          _fulltext += entry.preferredName + ' '

    # ++
    if efJSON?.hierarchicalSuperiorOfTheCorporateBody and fulltextConfig?.hierarchicalSuperiorOfTheCorporateBody
      for entry in efJSON.hierarchicalSuperiorOfTheCorporateBody
        if entry.preferredName
          _fulltext += entry.preferredName + ' '

    # ++
    if efJSON?.broaderTermInstantial and fulltextConfig?.broaderTermInstantial
      for entry in efJSON.broaderTermInstantial
        if entry.preferredName
          _fulltext += entry.preferredName + ' '

    # ++
    if efJSON?.broaderTermGeneral and fulltextConfig?.broaderTermGeneral
      for entry in efJSON.broaderTermGeneral
        if entry.preferredName
          _fulltext += entry.preferredName + ' '

    # ++
    if efJSON?.professionOrOccupation and fulltextConfig?.professionOrOccupation
      for entry in efJSON.professionOrOccupation
        if entry.preferredName
          _fulltext += entry.preferredName + ' '

    if efJSON?.architect and fulltextConfig?.architect
      for entry in efJSON.architect
        if entry.preferredName
          _fulltext += entry.preferredName + ' '

    if efJSON?.opusNumericDesignationOfMusicalWork and fulltextConfig?.opusNumericDesignationOfMusicalWork
      for entry in efJSON.opusNumericDesignationOfMusicalWork
          _fulltext += entry + ' '

    # ++
    if efJSON?.definition and fulltextConfig?.definition
      for entry in efJSON.definition
          _fulltext += entry + ' '

    return _fulltext


  @getGEOJSONFromObject: (object) ->
    geoJSON = false
    if object?.location
        if object.location?.geometry
            if object.location.geometry?.coordinates
                geoJSON = object.location
       
    else if object?.hasGeometry
        # Extract and convert the coordinates directly
        wkt = object.hasGeometry[0].asWKT[0]
        coordinates = wkt.replace('Point (', '').replace(')', '').split(' ').filter (item) -> item.trim() != ''
        longitude = parseFloat(coordinates[0])
        latitude = parseFloat(coordinates[1])

        geoJSON = 
          type: "Feature"
          geometry: 
            type: object.hasGeometry[0].type
            coordinates: [longitude, latitude]
          properties: {}

    return geoJSON

    
  @getStandardTextFromObject: (context, object, cdata, databaseLanguages = false) ->

    if databaseLanguages == false
      databaseLanguages = ez5.loca.getDatabaseLanguages()

    shortenedDatabaseLanguages = databaseLanguages.map((value, key, array) ->
      value.split('-').shift()
    )

    activeFrontendLanguage = null
    if context
      activeFrontendLanguage = context.getFrontendLanguage()

    if cdata?.frontendLanguage
        if cdata?.frontendLanguage?.length == 2
          activeFrontendLanguage = cdata.frontendLanguage

    _standard = {}
    l10nObject = {}

    # init l10nObject for fulltext
    for language in databaseLanguages
      l10nObject[language] = cdata.conceptName

    #  give l10n-languages the easydb-language-syntax
    for l10nObjectKey, l10nObjectValue of l10nObject
      # get shortened version
      shortenedLanguage = l10nObjectKey.split('-')[0]
      # add to l10n
      l10nObject[l10nObjectKey] = cdata.conceptName

    _standard.l10ntext = l10nObject
    
    geoJSON = @.getGEOJSONFromObject(object)
    if geoJSON
        _standard.geo = geoJSON
    
    return _standard



  ########################################################################
  #generates a json-structure, which is only used for facetting (aka filter) in frontend
  ########################################################################
  @getFacetTerm: (cdata, databaseLanguages) ->

    shortenedDatabaseLanguages = databaseLanguages.map((value, key, array) ->
      value.split('-').shift()
    )

    _facet_term = {}
    l10nObject = {}

    # init l10nObject
    for language in databaseLanguages
      l10nObject[language] = cdata.conceptName + '@$@' + cdata.conceptURI

    # if l10n-object is not empty
    _facet_term = l10nObject
    return _facet_term