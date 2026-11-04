package net.sijawa.activity

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.util.Log
import android.widget.Button
import com.google.firebase.database.*
import io.supercharge.shimmerlayout.ShimmerLayout
import net.sijawa.R
import net.sijawa.common.Common
import net.sijawa.model.LevelOneQuestion
import uk.co.chrisjenx.calligraphy.CalligraphyConfig
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper
import java.util.*
import java.util.Collections.shuffle


class StartOneActivity : AppCompatActivity() {

    internal lateinit var shimmerLayout: ShimmerLayout

    internal lateinit var btnPlay: Button
    internal lateinit var database: FirebaseDatabase
    internal lateinit var questions: DatabaseReference
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        CalligraphyConfig.initDefault(
            CalligraphyConfig.Builder()
                .setDefaultFontPath("fonts/Montserrat-Bold.ttf")
                .setFontAttrId(R.attr.fontPath)
                .build()
        )
        setContentView(R.layout.activity_start_one)

        database = FirebaseDatabase.getInstance()
        questions = database.getReference("Quesone")

        loadQuestion(Common.categoryId!!)
        btnPlay = findViewById<Button>(R.id.btnMain)
        btnPlay.setOnClickListener {
            val intent = Intent(this@StartOneActivity, PlayingOne::class.java)
            startActivity(intent)
            finish()
        }

    }

    private fun loadQuestion(categoryId: String) {

        //clear list if have old ques
        if (Common.questionList.size > 0)
            Common.questionList.clear()

        questions.orderByChild("CategoryId").equalTo(categoryId)
            .addValueEventListener(object : ValueEventListener {
                override fun onDataChange(dataSnapshot: DataSnapshot) {
                    for (postSnapshot in dataSnapshot.children) {
                        val ques = postSnapshot.getValue(LevelOneQuestion::class.java!!)
                        Common.questionList.add(ques!!)

                    }
                }

                override fun onCancelled(databaseError: DatabaseError) {

                }
            })
        //Random list
        Collections.shuffle(Common.questionList)
    }



    override fun attachBaseContext(newBase: Context) {
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase))
    }




}









