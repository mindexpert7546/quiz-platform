const express = require("express");
const router = express.Router();
const Quiz = require("../models/Quiz");
const { nanoid } = require("nanoid");


// CREATE QUIZ
router.post("/create", async (req,res)=>{

const quizCode = nanoid(6);

const quiz = new Quiz({
title:req.body.title,
description:req.body.description,
createdBy:req.body.createdBy,
category:req.body.category,
profile:req.body.profile,
quizCode:quizCode,
questions:req.body.questions
});

await quiz.save();

res.json({
message:"Quiz Created",
quizLink:`/quiz.html?code=${quizCode}`
});

});


// GET ALL QUIZZES  (PUT THIS BEFORE :code)
router.get("/all", async(req,res)=>{

const category = req.query.category;

let filter = {};

if(category && category !== "ALL"){
filter.category = category;
}

const quizzes = await Quiz.find(filter).sort({createdAt:-1});

res.json(quizzes);

});


// GET QUIZ BY CODE
router.get("/:code", async(req,res)=>{

const quiz = await Quiz.findOne({quizCode:req.params.code});

if(!quiz){
return res.status(404).json({message:"Quiz not found"});
}

const requiresToken = quiz.questions.length > 10;
const providedToken = req.query.token;

if(requiresToken && providedToken !== "bpsctrebykundan"){
    return res.json({
        title: quiz.title,
        description: quiz.description,
        createdBy: quiz.createdBy,
        category: quiz.category,
        profile: quiz.profile,
        quizCode: quiz.quizCode,
        requiresToken: true,
        questions: [] // Don't send questions without token
    });
}

res.json({
...quiz.toObject(),
requiresToken
});

});


// DELETE QUIZ
router.delete("/delete/:id", async(req,res)=>{

const token = req.body.token;

if(token !== "KUNDAN"){
return res.status(403).json({message:"Invalid token"});
}

await Quiz.findByIdAndDelete(req.params.id);

res.json({message:"Quiz Deleted Successfully"});

});

module.exports = router;