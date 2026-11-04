package net.sijawa.activity

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import net.sijawa.R
import android.R.menu
import android.content.Context
import android.content.Intent
import android.os.CountDownTimer
import android.os.Handler
import android.view.animation.Animation
import android.view.animation.AnimationUtils
import com.felipecsl.gifimageview.library.GifImageView
import kotlinx.android.synthetic.main.activity_splash.*

import net.sijawa.fragment.BelajarFragment
import org.apache.commons.io.IOUtils
import uk.co.chrisjenx.calligraphy.CalligraphyConfig
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper
import java.io.IOException


class SplashActivity : AppCompatActivity() {
    lateinit var gifImageView: GifImageView
    internal lateinit var fromtopbottom: Animation
    internal lateinit var smtobig: Animation

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        CalligraphyConfig.initDefault(
            CalligraphyConfig.Builder()
                .setDefaultFontPath("fonts/MontserratAlternates-Bold.otf")
                .setFontAttrId(R.attr.fontPath)
                .build()
        )
        setContentView(R.layout.activity_splash)
        fromtopbottom = AnimationUtils.loadAnimation(this, R.anim.fromtopbottom)
        smtobig = AnimationUtils.loadAnimation(this, R.anim.smtobig)
        iv.startAnimation(smtobig)
        bottom.startAnimation(fromtopbottom)

        val thread = object : Thread() {
            override fun run() {
                try {
                    Thread.sleep(3000)
                } catch (ex: InterruptedException) {
                    ex.printStackTrace()
                } finally {
                    startActivity(Intent(this@SplashActivity, MainActivity::class.java))
                    finish() // Menutup Activity
                }
            }
        }
        thread.start()
    }

    override fun attachBaseContext(newBase: Context) {
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase))
    }
}
