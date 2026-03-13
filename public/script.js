// -------------------------------
// CREATE QUIZ FUNCTION
// -------------------------------

async function createQuiz(event){

event.preventDefault()

const btn = document.getElementById("submitBtn")
const loader = document.getElementById("loader")
const message = document.getElementById("message")

let title = document.getElementById("title").value
let description = document.getElementById("description").value
let creator = document.getElementById("creator").value
let questionsText = document.getElementById("questions").value
let category = document.getElementById("category").value
let profile = document.getElementById("profile").value

message.innerHTML=""
message.className="message"

if(!title || !creator || !questionsText){
message.innerHTML="Please fill all required fields"
message.classList.add("error")
return
}

let questions

try{
questions = JSON.parse(questionsText)
}catch(e){
message.innerHTML="Invalid JSON format"
message.classList.add("error")
return
}

if(questions.length < 10){
message.innerHTML="Minimum 10 questions required"
message.classList.add("error")
return
}

btn.disabled=true
loader.style.display="block"

try{

let res = await fetch("/api/quiz/create",{
method:"POST",
headers:{
"Content-Type":"application/json"
},
body:JSON.stringify({
title,
description,
createdBy:creator,
category,
profile,
questions
})
})

if(!res.ok){
throw new Error("Server error")
}

let result = await res.json()

loader.style.display="none"

const fullLink = window.location.origin + result.quizLink

message.classList.add("success")
message.innerHTML=
`Quiz Created Successfully!<br><br>
<a href="${fullLink}" target="_blank">${fullLink}</a>`

document.getElementById("quizForm").reset()

btn.disabled=false

}catch(err){

loader.style.display="none"

message.classList.add("error")
message.innerHTML="Failed to create quiz. Please try again."

btn.disabled=false

}

}


// -------------------------------
// QUIZ PLAY LOGIC
// -------------------------------

let quizData = null
let currentQuestion = 0
let answers = []

const params = new URLSearchParams(window.location.search)
const quizCode = params.get("code")
const studentName = params.get("name") || "Anonymous"


// -------------------------------
// LOAD QUIZ
// -------------------------------

async function loadQuiz(){

if(!quizCode) return

let res = await fetch("/api/quiz/" + quizCode)

quizData = await res.json()

document.getElementById("quizTitle").innerText = quizData.title

document.getElementById("creatorInfo").innerText =
"Created By: " + quizData.createdBy

showQuestion()

}


// -------------------------------
// SHOW QUESTION
// -------------------------------

function showQuestion(){

let q = quizData.questions[currentQuestion]

document.getElementById("progress").innerText =
"Question " + (currentQuestion+1) + " of " + quizData.questions.length

let html = `<h3>${q.question}</h3>`

q.options.forEach((opt,index)=>{

let selected = answers[currentQuestion] == index ? "checked" : ""

html += `
<label class="option" onclick="selectOption(${index})">
<input type="radio" name="option" value="${index}" ${selected} hidden>
${opt.text}
</label>
`

})

document.getElementById("questionContainer").innerHTML = html

updateProgressBar()

restoreAnswerState()
updateButtons()
}


// -------------------------------
// PROGRESS BAR
// -------------------------------

function updateProgressBar(){

let percent = ((currentQuestion+1)/quizData.questions.length)*100

document.getElementById("progressFill").style.width = percent + "%"

}


// -------------------------------
// RESTORE ANSWER STATE
// -------------------------------

function restoreAnswerState(){

let saved = answers[currentQuestion]

if(saved === undefined) return

let q = quizData.questions[currentQuestion]

let options = document.querySelectorAll(".option")

options.forEach((opt,i)=>{

opt.classList.add("disabled")

if(q.options[i].isCorrect){
opt.classList.add("correct")
}

if(i == saved && !q.options[i].isCorrect){
opt.classList.add("wrong")
}

})

}


// -------------------------------
// SELECT OPTION
// -------------------------------

function selectOption(index){

if(answers[currentQuestion] !== undefined){
return
}

answers[currentQuestion] = index

let q = quizData.questions[currentQuestion]

let options = document.querySelectorAll(".option")

options.forEach((opt,i)=>{

opt.classList.add("disabled")

if(q.options[i].isCorrect){
opt.classList.add("correct")
}

if(i == index && !q.options[i].isCorrect){
opt.classList.add("wrong")
}

})

}


// -------------------------------
// SAVE ANSWER
// -------------------------------

function saveAnswer(){

let selected = document.querySelector('input[name="option"]:checked')

if(selected){
answers[currentQuestion] = parseInt(selected.value)
}

}


// -------------------------------
// NEXT QUESTION
// -------------------------------

function nextQuestion(){

saveAnswer()

if(currentQuestion < quizData.questions.length-1){
currentQuestion++
showQuestion()
}

}


// -------------------------------
// PREVIOUS QUESTION
// -------------------------------

function prevQuestion(){

saveAnswer()

if(currentQuestion > 0){
currentQuestion--
showQuestion()
}

}


// -------------------------------
// SUBMIT QUIZ
// -------------------------------

function submitQuiz(){

let score = 0
let unanswered = 0

quizData.questions.forEach((q,index)=>{

if(answers[index] === undefined){
unanswered++
}
else if(q.options[answers[index]]?.isCorrect){
score++
}

})

let percent = Math.round((score/quizData.questions.length)*100)

let status = percent >= 50
? '<div class="report-pass">PASSED</div>'
: '<div class="report-fail">FAILED</div>'

document.getElementById("questionContainer").innerHTML=""
document.getElementById("progress").innerHTML=""
document.getElementById("progressFill").style.width = "100%"

document.getElementById("result").innerHTML = `
<div class="report-card">

<h2>🎓 Quiz Report Card</h2>

<p><strong>Student:</strong> ${studentName}</p>
<p><strong>Quiz:</strong> ${quizData.title}</p>
<p><strong>Date:</strong> ${new Date().toLocaleString()}</p>

<div class="report-score">${score} / ${quizData.questions.length}</div>

<div>${percent}% Score</div>

<br>

<div>Correct Answers: ${score}</div>
<div>Unanswered: ${unanswered}</div>

<br>

${status}

<br>

<p>Created By: ${quizData.createdBy}</p>

<br>

<button onclick="downloadReport()" style="margin-top:15px;background:#00e5ff;border:none;padding:10px 18px;border-radius:6px;cursor:pointer;">
Download Report PDF
</button>

</div>
`

}

// -------------------------------
// DOWNLOAD REPORT PDF
// -------------------------------

function downloadReport(){

const { jsPDF } = window.jspdf

const doc = new jsPDF()

let y = 20

doc.setFontSize(18)
doc.text("Quiz Report", 20, y)

y += 10

doc.setFontSize(12)

doc.text("Student: " + studentName, 20, y)
y += 7

doc.text("Quiz: " + quizData.title, 20, y)
y += 7

doc.text("Created By: " + quizData.createdBy, 20, y)
y += 7

doc.text("Date: " + new Date().toLocaleString(), 20, y)

y += 12

let score = 0

quizData.questions.forEach((q,index)=>{

let selected = answers[index]
let correctIndex = q.options.findIndex(o => o.isCorrect)

if(selected === correctIndex){
score++
}

doc.setFontSize(12)

doc.text((index+1)+". "+q.question, 20, y)

y += 7

let selectedText = selected !== undefined ? q.options[selected].text : "Not Answered"

doc.text("Your Answer: "+selectedText, 25, y)

y += 7

doc.text("Correct Answer: "+q.options[correctIndex].text, 25, y)

y += 10

// new page if needed
if(y > 270){
doc.addPage()
y = 20
}

})

doc.save("quiz-report.pdf")

}

function updateButtons(){

const prevBtn = document.getElementById("prevBtn")
const nextBtn = document.getElementById("nextBtn")

// disable previous if first question
if(currentQuestion === 0){
prevBtn.disabled = true
prevBtn.style.opacity = "0.5"
}else{
prevBtn.disabled = false
prevBtn.style.opacity = "1"
}

// disable next if last question
if(currentQuestion === quizData.questions.length - 1){
nextBtn.disabled = true
nextBtn.style.opacity = "0.5"
}else{
nextBtn.disabled = false
nextBtn.style.opacity = "1"
}

}

// -------------------------------
// START
// -------------------------------

loadQuiz()