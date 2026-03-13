// -------------------------------
// CREATE QUIZ FUNCTION
// -------------------------------

async function createQuiz(){

let title = document.getElementById("title").value
let description = document.getElementById("description").value
let creator = document.getElementById("creator").value
let questionsText = document.getElementById("questions").value

if(!title || !creator || !questionsText){
alert("Please fill all fields")
return
}

let questions

try{
questions = JSON.parse(questionsText)
}catch(e){
alert("Invalid JSON format")
return
}

if(questions.length < 10){
alert("Minimum 10 questions required")
return
}

let data = {
title:title,
description:description,
createdBy:creator,
questions:questions
}

let res = await fetch("/api/quiz/create",{
method:"POST",
headers:{
"Content-Type":"application/json"
},
body:JSON.stringify(data)
})

let result = await res.json()

document.getElementById("link").innerHTML =
`Quiz Created! <br><br>
<a href="${result.quizLink}" target="_blank">${result.quizLink}</a>`

}


// -------------------------------
// QUIZ PLAY LOGIC
// -------------------------------

let quizData = null
let currentQuestion = 0
let answers = []

const params = new URLSearchParams(window.location.search)
const quizCode = params.get("code")

async function loadQuiz(){

if(!quizCode) return

let res = await fetch("/api/quiz/" + quizCode)

quizData = await res.json()

document.getElementById("quizTitle").innerText = quizData.title

document.getElementById("creatorInfo").innerText =
"Created By: " + quizData.createdBy

showQuestion()

}

function showQuestion(){

let q = quizData.questions[currentQuestion]

document.getElementById("progress").innerText =
"Question " + (currentQuestion+1) + " of " + quizData.questions.length

let html = `<h3>${q.question}</h3>`

q.options.forEach((opt,index)=>{

let checked = answers[currentQuestion] == index ? "checked" : ""

html += `
<label>
<input type="radio" name="option" value="${index}" ${checked}>
${opt.text}
</label><br>
`

})

document.getElementById("questionContainer").innerHTML = html

}

function saveAnswer(){

let selected = document.querySelector('input[name="option"]:checked')

if(selected){
answers[currentQuestion] = selected.value
}

}

function nextQuestion(){

saveAnswer()

if(currentQuestion < quizData.questions.length-1){
currentQuestion++
showQuestion()
}

}

function prevQuestion(){

saveAnswer()

if(currentQuestion > 0){
currentQuestion--
showQuestion()
}

}

function submitQuiz(){

saveAnswer()

let score = 0

quizData.questions.forEach((q,index)=>{

if(q.options[answers[index]]?.isCorrect){
score++
}

})

document.getElementById("result").innerHTML =
`Quiz Completed!<br>
Score: ${score} / ${quizData.questions.length}<br>
Created By: ${quizData.createdBy}`

}

loadQuiz()