package net.sijawa.activity

import android.content.Context
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.ProgressBar
import android.widget.TextView
import kotlinx.android.synthetic.main.activity_done_one.*
import net.sijawa.R
import uk.co.chrisjenx.calligraphy.CalligraphyConfig
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper

class DoneTwo : AppCompatActivity() {

    internal lateinit var btnTryAgain: Button
    internal lateinit var txtResultScore: TextView
    internal lateinit var getTxtResultQuestion: TextView
    internal lateinit var progressBar: ProgressBar

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        CalligraphyConfig.initDefault(
            CalligraphyConfig.Builder()
                .setDefaultFontPath("fonts/Montserrat-Bold.ttf")
                .setFontAttrId(R.attr.fontPath)
                .build()
        )
        setContentView(R.layout.activity_done_two)

        txtResultScore = findViewById<TextView>(R.id.txtTotalScore)
        btnTryAgain = findViewById<Button>(R.id.btnTryAgain)

        btnTryAgain.setOnClickListener(View.OnClickListener {
            val intent = Intent(this@DoneTwo, MainActivity::class.java)
            startActivity(intent)
            finish()
        })
        //get data from bundle
        val extra = intent.extras
        if (extra != null) {
            val score = extra.getInt("SCORE")
            val totalQuestion = extra.getInt("TOTAL")
            val correctAnswer = extra.getInt("CORRECT")

            if(score > 75){
                card.setBackgroundResource(R.drawable.c_menang)
                ucapan.text = "Selamat ya...\nNilai Kamu"
            }

            txtResultScore.text = String.format("%d", score)

        }
    }
    override fun attachBaseContext(newBase: Context) {
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase))
    }
}

