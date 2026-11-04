package net.sijawa.fragment

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import android.support.v4.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.Toast
import net.sijawa.R
import net.sijawa.activity.Level1Activity
import net.sijawa.activity.Level2Activity
import net.sijawa.activity.Level3Activity
import net.sijawa.activity.PenggunaanBahasaJawaActivity

class QuizFragment : Fragment() {

    lateinit var level1: FrameLayout
    lateinit var level2: FrameLayout
    lateinit var level3: FrameLayout

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        // Inflate the layout for this fragment
        val view = inflater.inflate(R.layout.fragment_quiz, container, false)

        level1 = view.findViewById(R.id.level1)
        level1.setOnClickListener {
            val a = Intent(activity, Level1Activity::class.java)
            startActivity(a)
            Toast.makeText(activity, "Memuat Data...", Toast.LENGTH_SHORT).show()
        }

        level2 = view.findViewById(R.id.level2)
        level2.setOnClickListener {
            val a = Intent(activity, Level2Activity::class.java)
            startActivity(a)
            Toast.makeText(activity, "Memuat Data...", Toast.LENGTH_SHORT).show()

        }

        level3 = view.findViewById(R.id.level3)
        level3.setOnClickListener {
            val a = Intent(activity, Level3Activity::class.java)
            startActivity(a)
            Toast.makeText(activity, "Memuat Data...", Toast.LENGTH_SHORT).show()


        }

        return view
    }

    companion object {
        fun newInstance(): QuizFragment{
            val fragment = QuizFragment()
            val args = Bundle()
            fragment.arguments = args
            return fragment
        }
    }
}