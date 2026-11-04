package net.sijawa.adapter

import android.content.Context
import android.content.Intent
import android.support.v4.content.ContextCompat.startActivity
import android.support.v4.view.PagerAdapter
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import net.sijawa.R
import net.sijawa.activity.*
import net.sijawa.model.ViewPager

class VpAdapter(private val models: List<ViewPager>, private val context: Context) : PagerAdapter() {
    private var layoutInflater: LayoutInflater? = null

    override fun getCount(): Int {
        return models.size
    }

    override fun isViewFromObject(view: View, `object`: Any): Boolean {
        return view == `object`
    }

    override fun instantiateItem(container: ViewGroup, position: Int): Any {
        layoutInflater = LayoutInflater.from(context)
        val view = layoutInflater!!.inflate(R.layout.item, container, false)

        val imageView: ImageView

        imageView = view.findViewById(R.id.img_slider)


        imageView.setImageResource(models[position].image!!)


        view.setOnClickListener(View.OnClickListener {
            when (position) {
                0 -> {
                    val a = Intent(context, PenggunaanNgokoActivity::class.java)
                    context.startActivity(a)
                }
                1 -> {
                    val a = Intent(context, PenggunaanKramaActivity::class.java)
                    context.startActivity(a)
                }
                2 -> {
                    val a = Intent(context, PenggunaanAngkaActivity::class.java)
                    context.startActivity(a)
                }
            }

        })

        container.addView(view, 0)
        return view
    }

    override fun destroyItem(container: ViewGroup, position: Int, `object`: Any) {

        container.removeView(`object` as View)
    }
}
