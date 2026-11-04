package net.sijawa.fragment

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.support.v4.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import net.sijawa.R
import net.sijawa.activity.PenggunaanBahasaJawaActivity
import android.text.method.LinkMovementMethod
import android.text.Html
import android.text.Spanned



class MoreFragment : Fragment() {
    lateinit var hafiz: FrameLayout
    lateinit var tata: FrameLayout
    lateinit var ucup: FrameLayout
    lateinit var credit: FrameLayout

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        // Inflate the layout for this fragment
        val view = inflater.inflate(R.layout.fragment_more, container, false)

        hafiz = view.findViewById(R.id.hafiz)
        hafiz.setOnClickListener {
            val a = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.linkedin.com/in/hafiznaufalr/"))
            startActivity(a)
        }

        tata = view.findViewById(R.id.tata)
        tata.setOnClickListener {
            val a = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.linkedin.com/in/muhammad-andika-tata-432285184/"))
            startActivity(a)
        }

        ucup = view.findViewById(R.id.ucup)
        ucup.setOnClickListener {
            val a = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.linkedin.com/in/yusuf-wibisono-509145174/"))
            startActivity(a)
        }
        credit = view.findViewById(R.id.credit)
        credit.setOnClickListener {
            val a = Intent(Intent.ACTION_VIEW, Uri.parse("https://docs.google.com/document/d/1QcpwJ6CTJJG2n4nBC7ZvgwS5AtPBSW_nWxliQWD22XQ/edit?usp=sharing"))
            startActivity(a)
        }


        return view
    }

    companion object {
        fun newInstance(): MoreFragment{
            val fragment = MoreFragment()
            val args = Bundle()
            fragment.arguments = args
            return fragment
        }
    }
}