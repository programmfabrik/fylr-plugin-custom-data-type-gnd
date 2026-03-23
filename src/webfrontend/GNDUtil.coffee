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

    # changed: lobid used 'id', entityfacts uses '@id'
    _fulltext += efJSON['@id'] + ' '

    # missing in entityfacts: gndIdentifier, replace with derivative of @id
    # _fulltext = efJSON['gndIdentifier'] + ' '
    _fulltext = efJSON['@id'].split('/').at(-1) + ' '

    # same in both: preferredName
    _fulltext += efJSON['preferredName'] + ' '

    if not pluginConfig?.fulltext_gnd
      return _fulltext

    fulltextConfig = pluginConfig.fulltext_gnd

    # missing in entityfacts: oldAuthorityNumber
    # if efJSON?.oldAuthorityNumber and fulltextConfig?.oldAuthorityNumber
    #   for entry in efJSON.oldAuthorityNumber
    #     _fulltext += entry + ' '

    # missing in entityfacts: gndSubjectCategory
    # if efJSON?.gndSubjectCategory and fulltextConfig?.gndSubjectCategory
    #   for entry in efJSON.gndSubjectCategory
    #     if entry.label
    #       _fulltext += entry.label + ' '

    # same in both: variantName
    if efJSON?.variantName and fulltextConfig?.variantName
      for entry in efJSON.variantName
        _fulltext += entry + ' '

    # same key in both; changed: lobid returns array, entityfacts returns a single string
    if efJSON?.biographicalOrHistoricalInformation and fulltextConfig?.biographicalOrHistoricalInformation
      _fulltext += efJSON.biographicalOrHistoricalInformation + ' '

    # same in both: dateOfEstablishment
    if efJSON?.dateOfEstablishment and fulltextConfig?.dateOfEstablishment
      for entry in efJSON.dateOfEstablishment
        _fulltext += entry + ' '

    # missing in entityfacts: dateOfPublication
    # if efJSON?.dateOfPublication and fulltextConfig?.dateOfPublication
    #   for entry in efJSON.dateOfPublication
    #     _fulltext += entry + ' '

    # same key in both; changed: lobid returns ISO date array, entityfacts returns a single formatted string
    if efJSON?.dateOfBirth and fulltextConfig?.dateOfBirth
      _fulltext += efJSON.dateOfBirth + ' '

    # same in both: dateOfProduction
    if efJSON?.dateOfProduction and fulltextConfig?.dateOfProduction
      _fulltext += efJSON.dateOfProduction + ' '

    # same key in both; changed: lobid returns ISO date array, entityfacts returns a single formatted string
    if efJSON?.dateOfDeath and fulltextConfig?.dateOfDeath
      _fulltext += efJSON.dateOfDeath + ' '

    # same in both: dateOfTermination
    if efJSON?.dateOfTermination and fulltextConfig?.dateOfTermination
      _fulltext += efJSON.dateOfTermination + ' '

    # missing in entityfacts: author
    # if efJSON?.author and fulltextConfig?.author
    #   for entry in efJSON.author
    #     if entry.label
    #       _fulltext += entry.label + ' '

    # missing in entityfacts: firstAuthor
    # if efJSON?.firstAuthor and fulltextConfig?.firstAuthor
    #   for entry in efJSON.firstAuthor
    #     if entry.label
    #       _fulltext += entry.label + ' '

    # same in both: organizerOrHost
    if efJSON?.organizerOrHost and fulltextConfig?.organizerOrHost
      for entry in efJSON.organizerOrHost
        if entry.label
          _fulltext += entry.label + ' '

    # same in both: gender
    if efJSON?.gender and fulltextConfig?.gender
      for entry in efJSON.gender
        if entry.label
          _fulltext += entry.label + ' '

    # same in both: placeOfEvent
    if efJSON?.placeOfEvent and fulltextConfig?.placeOfEvent
      for entry in efJSON.placeOfEvent
        if entry.label
          _fulltext += entry.label + ' '

    # same in both: placeOfBirth
    if efJSON?.placeOfBirth and fulltextConfig?.placeOfBirth
      for entry in efJSON.placeOfBirth
        if entry.label
          _fulltext += entry.label + ' '

    # same in both: placeOfDeath
    if efJSON?.placeOfDeath and fulltextConfig?.placeOfDeath
      for entry in efJSON.placeOfDeath
        if entry.label
          _fulltext += entry.label + ' '

    # same in both: placeOfBusiness
    if efJSON?.placeOfBusiness and fulltextConfig?.placeOfBusiness
      for entry in efJSON.placeOfBusiness
        if entry.label
          _fulltext += entry.label + ' '

    # same in both: associatedPlace
    if efJSON?.associatedPlace and fulltextConfig?.associatedPlace
      for entry in efJSON.associatedPlace
        if entry.label
          _fulltext += entry.label + ' '

    # missing in entityfacts: topic
    # if efJSON?.topic and fulltextConfig?.topic
    #   for entry in efJSON.topic
    #     if entry.label
    #       _fulltext += entry.label + ' '

    # same in both: predecessor
    if efJSON?.predecessor and fulltextConfig?.predecessor
      for entry in efJSON.predecessor
        if entry.label
          _fulltext += entry.label + ' '

    # changed: lobid 'precedingCorporateBody' is now covered by 'predecessor' in entityfacts (handled above)
    # if efJSON?.precedingCorporateBody and fulltextConfig?.precedingCorporateBody
    #   for entry in efJSON.precedingCorporateBody
    #     if entry.label
    #       _fulltext += entry.label + ' '

    # same in both: isA
    if efJSON?.isA and fulltextConfig?.isA
      for entry in efJSON.isA
        if entry.label
          _fulltext += entry.label + ' '

    # missing in entityfacts: composer
    # if efJSON?.composer and fulltextConfig?.composer
    #   for entry in efJSON.composer
    #     if entry.label
    #       _fulltext += entry.label + ' '

    # missing in entityfacts: relatedWork
    # if efJSON?.relatedWork and fulltextConfig?.relatedWork
    #   for entry in efJSON.relatedWork
    #     if entry.label
    #       _fulltext += entry.label + ' '

    # same in both: relatedPerson
    if efJSON?.relatedPerson and fulltextConfig?.relatedPerson
      for entry in efJSON.relatedPerson
        if entry.label
          _fulltext += entry.label + ' '

    # changed: lobid 'precedingPlaceOrGeographicName' is now covered by 'predecessor' in entityfacts (handled above)
    # if efJSON?.precedingPlaceOrGeographicName and fulltextConfig?.precedingPlaceOrGeographicName
    #   for entry in efJSON.precedingPlaceOrGeographicName
    #     if entry.label
    #       _fulltext += entry.label + ' '

    # changed: lobid 'hierarchicalSuperiorOfTheCorporateBody' -> entityfacts 'isPartOf'
    if efJSON?.isPartOf and fulltextConfig?.hierarchicalSuperiorOfTheCorporateBody
      for entry in efJSON.isPartOf
        if entry.label
          _fulltext += entry.label + ' '

    # missing in entityfacts: broaderTermInstantial
    # if efJSON?.broaderTermInstantial and fulltextConfig?.broaderTermInstantial
    #   for entry in efJSON.broaderTermInstantial
    #     if entry.label
    #       _fulltext += entry.label + ' '

    # missing in entityfacts: broaderTermGeneral
    # if efJSON?.broaderTermGeneral and fulltextConfig?.broaderTermGeneral
    #   for entry in efJSON.broaderTermGeneral
    #     if entry.label
    #       _fulltext += entry.label + ' '

    # same in both: professionOrOccupation
    if efJSON?.professionOrOccupation and fulltextConfig?.professionOrOccupation
      for entry in efJSON.professionOrOccupation
        if entry.label
          _fulltext += entry.label + ' '

    # same in both: architect
    if efJSON?.architect and fulltextConfig?.architect
      for entry in efJSON.architect
        if entry.label
          _fulltext += entry.label + ' '

    # missing in entityfacts: opusNumericDesignationOfMusicalWork
    # if efJSON?.opusNumericDesignationOfMusicalWork and fulltextConfig?.opusNumericDesignationOfMusicalWork
    #   for entry in efJSON.opusNumericDesignationOfMusicalWork
    #     _fulltext += entry + ' '

    # missing in entityfacts: definition
    # if efJSON?.definition and fulltextConfig?.definition
    #   for entry in efJSON.definition
    #     _fulltext += entry + ' '

    # changed: lobid 'succeedingCorporateBody' -> entityfacts 'successor'
    if efJSON?.successor and fulltextConfig?.succeedingCorporateBody
      for entry in efJSON.successor
        if entry.label
          _fulltext += entry.label + ' '

    # missing in entityfacts: succeedingPlaceOrGeographicName
    # if efJSON?.succeedingPlaceOrGeographicName and fulltextConfig?.succeedingPlaceOrGeographicName
    #   for entry in efJSON.succeedingPlaceOrGeographicName
    #     if entry.label
    #       _fulltext += entry.label + ' '

    if efJSON?.location and fulltextConfig?.location
      efJsonGeoJson = @.getGEOJSONFromObject(efJSON)
      if Array.isArray(efJsonGeoJson?.geometry?.coordinates)
        _fulltext += efJsonGeoJson.geometry.coordinates.join(" ")


    return _fulltext


  @getGEOJSONFromObject: (object) ->
    geoJSON = false
    if object?.location
        if object.location?.geometry
            if object.location.geometry?.coordinates
                objectLocation = structuredClone(object.location)
                objectLocation.properties ?= {}
                objectLocation.geometry.coordinates = objectLocation.geometry.coordinates.map (c) ->
                    if typeof c == 'string' then parseFloat(c) else c
                geoJSON = objectLocation

       
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