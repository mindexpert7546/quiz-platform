const express = require("express");
const router = express.Router();
const Quiz = require("../models/Quiz");
const { nanoid } = require("nanoid");


// create quiz
router.post("/create", async (req,res)=>{

const quizCode = nanoid(6);

const quiz = new Quiz({
title:req.body.title,
description:req.body.description,
createdBy:req.body.createdBy,
quizCode:quizCode,
questions:req.body.questions
});

await quiz.save();

res.json({
message:"Quiz Created",
quizLink:`http://localhost:3000/quiz.html?code=${quizCode}`
});

});


// get quiz by code
router.get("/:code", async(req,res)=>{

const quiz = await Quiz.findOne({quizCode:req.params.code});

res.json(quiz);

});

module.exports = router;