package net.sijawa.activity

import android.content.Context
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.os.CountDownTimer
import android.view.View
import android.widget.*
import com.squareup.picasso.Picasso
import net.sijawa.R
import net.sijawa.common.Common3
import uk.co.chrisjenx.calligraphy.CalligraphyConfig
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper

class PlayingThree : AppCompatActivity(), View.OnClickListener {

    internal val INTERVAL: Long = 4500
    internal val TIMEOUT: Long = 30000
    internal var progressValue = 0

    internal lateinit var mCountDown: CountDownTimer

    internal var index = 0
    internal var score = 0
    internal var thisQuestion = 0
    internal var totalQuestion:Int = 0
    internal var correctAnswer:Int = 0

    internal lateinit var progressBar: ProgressBar
    internal lateinit var question_image: ImageView
    internal lateinit var btnA: Button
    internal lateinit var btnB: Button
    internal lateinit var btnC: Button
    internal lateinit var btnD: Button
    internal lateinit var txtScore: TextView
    internal lateinit var txtQuestionNum: TextView
    internal lateinit var question_text: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        CalligraphyConfig.initDefault(
            CalligraphyConfig.Builder()
                .setDefaultFontPath("fonts/Montserrat-Bold.ttf")
                .setFontAttrId(R.attr.fontPath)
                .build()
        )
        setContentView(R.layout.activity_playing_three)


        //views
        txtQuestionNum = findViewById(R.id.txtTotalQuestion) as TextView
        question_text = findViewById(R.id.question_text) as TextView
        question_image = findViewById(R.id.question_image) as ImageView

        progressBar = findViewById(R.id.progressBar) as ProgressBar

        btnA = findViewById(R.id.btnAnswerA) as Button
        btnB = findViewById(R.id.btnAnswerB) as Button
        btnC = findViewById(R.id.btnAnswerC) as Button

        btnA.setOnClickListener(this)
        btnB.setOnClickListener(this)
        btnC.setOnClickListener(this)
    }

    override fun onClick(view: View) {

        mCountDown.cancel()
        if (index < totalQuestion)
        //masih ada quest di list
        {
            val clickedButton = view as Button
            if (clickedButton.text == Common3.questionList[index].CorrectAnswer) {
                //pilih jawaban benar
                score += 10
                correctAnswer++
                showQuestion(++index) //quest selanjutnya
            } else {
                //jika jawaban salah
                showQuestion(++index) //quest selanjutnya
            }

        }

    }

    private fun showQuestion(index: Int) {
        if (index < totalQuestion) {
            thisQuestion++
            txtQuestionNum.setText(String.format("%d / %d", thisQuestion, totalQuestion))
            progressBar.progress = 0
            progressValue = 0

            if (Common3.questionList.get(index).IsImageQuestion.equals("true")) {
                //jika soal gambar
                Picasso.with(this)
                    .load(Common3.questionList.get(index).QuestionImg)
                    .into(question_image)
                question_text.setText(Common3.questionList.get(index).Question)
                question_image.visibility = View.VISIBLE
                question_text.setVisibility(View.VISIBLE)
            } else {
                question_text.setText(Common3.questionList.get(index).Question)

                question_image.visibility = View.INVISIBLE
                question_text.setVisibility(View.VISIBLE)
            }

            btnA.text = Common3.questionList[index].AnswerA
            btnB.text = Common3.questionList[index].AnswerB
            btnC.text = Common3.questionList[index].AnswerC

            mCountDown.start() //timer jalan
        } else {
            //question terakhir
            val intent = Intent(this, DoneTwo::class.java)
            val dataSend = Bundle()
            dataSend.putInt("SCORE", score)
            dataSend.putInt("TOTAL", totalQuestion)
            dataSend.putInt("CORRECT", correctAnswer)
            intent.putExtras(dataSend)
            startActivity(intent)
            finish()
        }

    }

    override fun onResume() {
        super.onResume()

        totalQuestion = Common3.questionList.size
        mCountDown = object : CountDownTimer(TIMEOUT, INTERVAL) {
            override fun onTick(minisec: Long) {
                progressBar.progress = progressValue
                progressValue++

            }

            override fun onFinish() {
                mCountDown.cancel()
                showQuestion(++index)
            }
        }
        showQuestion(index)
    }
    override fun attachBaseContext(newBase: Context) {
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase))
    }
    override fun onBackPressed() {
        //No codes at all
        Toast.makeText(this@PlayingThree, "Selesaikan dulu yaa", Toast.LENGTH_SHORT ).show()
    }

}
