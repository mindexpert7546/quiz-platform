const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const quizRoutes = require("./routes/quizRoutes");

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.static("public"));

mongoose.connect("mongodb+srv://sportsact7_db_user:vjoYSRd1FeCiG711@cluster0.cgdpn5e.mongodb.net/?appName=Cluster0")
.then(()=>console.log("Database connected"))
.catch(err=>console.log(err));

app.use("/api/quiz", quizRoutes);

app.listen(3000, ()=>{
console.log("Server running on port 3000");
});