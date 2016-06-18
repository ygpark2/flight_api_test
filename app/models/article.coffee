# Example model


module.exports = (sequelize, DataTypes) ->

  sequelize.define 'Article',
    title: DataTypes.STRING,
    url: DataTypes.STRING,
    text: DataTypes.STRING
  ,
    classMethods:
      associate: (models) ->
        # example on how to add relations
        # Article.hasMany models.Comments

