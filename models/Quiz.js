const mongoose = require("mongoose");

const OptionSchema = new mongoose.Schema({
text:String,
isCorrect:Boolean
});

const QuestionSchema = new mongoose.Schema({
question:String,
options:[OptionSchema]
});

const QuizSchema = new mongoose.Schema({

title:String,
description:String,
createdBy:String,
quizCode:String,
questions:[QuestionSchema],

createdAt:{
type:Date,
default:Date.now
}

});

module.exports = mongoose.model("Quiz", QuizSchema);