enableFileupload = () ->
  fileTypes = [
    "image/png"
    "image/jpeg"
    "image/gif"
  ]
  awsSetting = Meteor.settings.aws
  Slingshot.createDirective CONSTANTS.UPLOADER, Slingshot.S3Storage,
    acl: "public-read"
    bucket: awsSetting.bucket
    region: awsSetting.region
    AWSAccessKeyId: awsSetting.AWSAccessKeyId
    AWSSecretAccessKey: awsSetting.AWSSecretAccessKey
    authorize: () ->
      true
    maxSize: 10 * 1024 * 1024
    allowedFileTypes: fileTypes
    key: (file) ->
      chance = new Chance()
      hash = chance.hash()
      fileName = if file and file.name then file.name else "unknown"
      fileName = fileName.toLowerCase()
      uniqueFn = "#{hash}_#{fileName}"

Meteor.startup () ->
  enableFileupload()
  Accounts.validateNewUser () ->
    false
