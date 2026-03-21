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

if(quizData.requiresToken && quizData.questions.length === 0){
    const token = prompt("This quiz requires a token to access. Please enter the token:");
    if(!token){
        alert("Token required to access this quiz.");
        return;
    }
    // Fetch again with token
    res = await fetch("/api/quiz/" + quizCode + "?token=" + encodeURIComponent(token))
    quizData = await res.json()
    if(quizData.questions.length === 0){
        alert("Invalid token. Access denied.");
        return;
    }
}

document.getElementById("quizTitle").innerText = quizData.title

document.getElementById("creatorInfo").innerText =
"Created By: " + quizData.createdBy

showQuestion()

// Clean URL after quiz loads to keep the address bar neat
if (window.history && window.history.replaceState) {
  const cleanPath = window.location.pathname
  window.history.replaceState({}, document.title, cleanPath)
}

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

// hide controls after submit
const controls = document.querySelector(".controls")
if (controls) controls.style.display = "none"

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

<div style="margin-top:15px;display:flex;gap:10px;flex-wrap:wrap;">
<button onclick="downloadReport()" style="background:#00e5ff;border:none;padding:10px 18px;border-radius:6px;cursor:pointer;">
Download Report PDF
</button>
<button onclick="downloadQuestionsPdf()" style="background:#1fae5e;border:none;padding:10px 18px;border-radius:6px;cursor:pointer;">
Download Questions PDF
</button>
<button onclick="downloadPresentation()" style="background:#ff8c00;border:none;padding:10px 18px;border-radius:6px;cursor:pointer;">
Download Presentation
</button>
</div>

</div>
`

}

// -------------------------------
// DOWNLOAD REPORT PDF
// -------------------------------

function downloadReport(){
  const { jsPDF } = window.jspdf
  const doc = new jsPDF({ unit: "pt", format: "a4" })
  const margin = 36
  let y = margin

  doc.setFillColor(20, 90, 160)
  doc.rect(0, 0, doc.internal.pageSize.getWidth(), 92, "F")
  doc.setTextColor(255, 255, 255)
  doc.setFontSize(26)
  doc.text("CSE TRE 4.0", margin, 44)
  doc.setFontSize(16)
  doc.text("Quiz Report", margin, 68)
  doc.setFontSize(10)
  doc.text(`Quiz: ${quizData.title}`, margin, 86)

  y = 112
  const score = quizData.questions.reduce((acc, q, idx) => {
    const selected = answers[idx]
    const correct = q.options.findIndex(o => o.isCorrect)
    return acc + (selected === correct ? 1 : 0)
  }, 0)
  const percent = Math.round((score / quizData.questions.length) * 100)
  const isPass = percent >= 50

  doc.setFillColor(245, 248, 255)
  doc.roundedRect(margin, y, doc.internal.pageSize.getWidth() - margin * 2, 72, 10, 10, "F")
  doc.setFontSize(12)
  doc.setTextColor(20, 20, 20)
  doc.text(`Score: ${score} / ${quizData.questions.length} (${percent}%)`, margin + 12, y + 25)
  doc.setFontSize(12)
  if (isPass) {
    doc.setTextColor(0, 120, 0)
  } else {
    doc.setTextColor(180, 30, 30)
  }
  doc.text(`Status: ${isPass ? "PASSED ✅" : "FAILED ❌"}`, margin + 12, y + 45)
  y += 96

  const printWrapped = (text, x, startY, lineHeight, maxWidth) => {
    const lines = doc.splitTextToSize(text, maxWidth)
    lines.forEach((line, i) => doc.text(line, x, startY + i * lineHeight))
    return startY + lines.length * lineHeight
  }

  const addPageIfNeeded = (heightNeeded) => {
    if (y + heightNeeded > doc.internal.pageSize.getHeight() - margin) {
      doc.addPage()
      y = margin
    }
  }

  quizData.questions.forEach((q, index) => {
    addPageIfNeeded(142)
    doc.setTextColor(16, 16, 16)
    doc.setFontSize(14)
    y = printWrapped(`${index + 1}. ${q.question}`, margin, y, 16, doc.internal.pageSize.getWidth() - margin * 2)
    y += 8

    q.options.forEach((opt, optIndex) => {
      const isCorrect = !!opt.isCorrect
      if (isCorrect) {
        doc.setFillColor(0, 140, 76)
      } else {
        doc.setFillColor(22, 115, 255)
      }
      const boxHeight = 24
      doc.roundedRect(margin, y, doc.internal.pageSize.getWidth() - margin * 2, boxHeight, 8, 8, "F")
      doc.setTextColor(255, 255, 255)
      doc.setFontSize(11)
      doc.text(`${String.fromCharCode(65 + optIndex)}. ${opt.text}`, margin + 10, y + 16, { maxWidth: doc.internal.pageSize.getWidth() - margin * 2 - 20 })
      y += boxHeight + 6
    })

    const selectedIdx = answers[index]
    const correctIdx = q.options.findIndex(o => o.isCorrect)
    const selectedText = selectedIdx === undefined ? "Not answered" : `${String.fromCharCode(65 + selectedIdx)}. ${q.options[selectedIdx].text}`
    const correctText = `${String.fromCharCode(65 + correctIdx)}. ${q.options[correctIdx].text}`

    doc.setTextColor(40, 40, 40)
    doc.setFontSize(10)
    doc.text(`Your answer: ${selectedText}`, margin + 10, y)
    y += 14
    doc.setTextColor(0, 120, 0)
    doc.text(`Correct answer: ${correctText}`, margin + 10, y)
    y += 14
    const isCorrect = selectedIdx === correctIdx
    doc.setTextColor(isCorrect ? 0 : 180, isCorrect ? 120 : 20, 20)
    doc.text(`Result: ${isCorrect ? "Correct" : "Incorrect"}`, margin + 10, y)
    y += 14

    doc.setDrawColor(200, 200, 200)
    doc.line(margin, y, doc.internal.pageSize.getWidth() - margin, y)
    y += 16
  })

  doc.save(`${quizData.title.replace(/\s+/g, "-").toLowerCase()}-report.pdf`)
}

function downloadQuestionsPdf(){
  const { jsPDF } = window.jspdf
  const doc = new jsPDF({ unit: "pt", format: "a4" })
  const margin = 40
  let y = margin

  doc.setFillColor(17, 83, 166)
  doc.rect(0, 0, doc.internal.pageSize.getWidth(), 80, "F")
  doc.setTextColor(255, 255, 255)
  doc.setFontSize(26)
  doc.text("CSE TRE 4.0", margin, 45)
  doc.setFontSize(14)
  doc.text("Questions & Answers By Kundan", margin, 65)

  y = 100
  doc.setTextColor(30, 30, 30)
  doc.setFontSize(12)
  // header bold
  doc.setFont("helvetica", "bold")
  doc.text(`${quizData.title}`, margin, y)
  y += 16
  doc.text(`Created by: ${quizData.createdBy}`, margin, y)
  doc.setFont("helvetica", "normal")
  y += 22

  const printWrapped = (text, x, startY, lineHeight, maxWidth) => {
    const lines = doc.splitTextToSize(text, maxWidth)
    lines.forEach((line, i) => doc.text(line, x, startY + i * lineHeight))
    return startY + lines.length * lineHeight
  }

  const addPageIfNeeded = (extraHeight) => {
    if (y + extraHeight > doc.internal.pageSize.getHeight() - margin) {
      doc.addPage()
      y = margin
    }
  }

  quizData.questions.forEach((q, index) => {
    addPageIfNeeded(170)
    doc.setTextColor(10, 10, 10)
    doc.setFontSize(13)
    y = printWrapped(`${index + 1}. ${q.question}`, margin, y, 16, doc.internal.pageSize.getWidth() - margin * 2)
    y += 8

    q.options.forEach((opt, oIndex) => {
      const isCorrect = !!opt.isCorrect
      const bg = isCorrect ? [0, 153, 68] : [57, 132, 255]
      const textClr = [255, 255, 255]
      const label = String.fromCharCode(65 + oIndex)
      const boxHeight = 24

      doc.setFillColor(...bg)
      doc.roundedRect(margin, y, doc.internal.pageSize.getWidth() - margin * 2, boxHeight, 6, 6, "F")
      doc.setTextColor(...textClr)
      doc.setFontSize(11)
      doc.text(`${label}. ${opt.text}`, margin + 10, y + 16, { maxWidth: doc.internal.pageSize.getWidth() - margin * 2 - 20 })
      y += boxHeight + 6
    })

    y += 6
    doc.setDrawColor(215, 215, 215)
    doc.line(margin, y, doc.internal.pageSize.getWidth() - margin, y)
    y += 14
  })

  doc.save(`${quizData.title.replace(/\s+/g, "-").toLowerCase()}-questions.pdf`)
}

function downloadPresentation(){
  if (typeof PptxGenJS === "undefined") {
    alert("Presentation library is not loaded. Please check your internet connection and reload the page.")
    return
  }

  const token = prompt("Enter token to generate presentation:")
  if (!token || token.trim().toUpperCase() !== "KUNDAN") {
    alert("Invalid token. Presentation generation cancelled.")
    return
  }

  const pres = new PptxGenJS()
  pres.defineLayout({ name: "LAYOUT_WIDE", width: 13.33, height: 7.5 })
  pres.layout = "LAYOUT_WIDE"

  const cover = pres.addSlide()
  cover.background = { fill: "003366" }
  cover.addText("CSE TRE 4.0", { x: 0.5, y: 1.2, w: 12.3, h: 1.2, color: "ffffff", fontSize: 32, bold: true, align: "center" })
  cover.addText(`Title: ${quizData.title}`, { x: 0.5, y: 2.8, w: 12.3, color: "ffffff", fontSize: 18, align: "center" })
  cover.addText(`Created by: ${quizData.createdBy}`, { x: 0.5, y: 3.4, w: 12.3, color: "ffffff", fontSize: 16, align: "center" })

  quizData.questions.forEach((q, index) => {
    const slide = pres.addSlide()
    slide.background = { fill: "f0f4ff" }
    slide.addText(`Question ${index + 1}`, { x: 0.5, y: 0.3, fontSize: 18, bold: true, color: "003366" })
    slide.addText(q.question, { x: 0.5, y: 1.1, w: 12.3, fontSize: 20, color: "000000", bold: true })

    q.options.forEach((opt, optIndex) => {
      const yPos = 1.9 + optIndex * 0.7
      slide.addText(`${String.fromCharCode(65 + optIndex)}. ${opt.text}`, {
        x: 0.5,
        y: yPos,
        w: 11.8,
        h: 0.5,
        color: "ffffff",
        fill: "2d71d9",
        fontSize: 14,
        margin: 0.08,
        bold: false,
        align: "left",
      })
    })
  })

  pres.writeFile({ fileName: `${quizData.title.replace(/\s+/g, "-").toLowerCase()}-presentation.pptx` })
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