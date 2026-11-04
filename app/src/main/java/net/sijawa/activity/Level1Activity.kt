package net.sijawa.activity

import android.content.Context
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.util.Log
import android.view.View
import com.firebase.ui.database.FirebaseRecyclerAdapter
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import com.squareup.picasso.Picasso
import io.supercharge.shimmerlayout.ShimmerLayout
import kotlinx.android.synthetic.main.activity_main.*
import net.sijawa.Interface.ItemClickListener
import net.sijawa.R
import net.sijawa.common.Common
import net.sijawa.model.LevelOne
import net.sijawa.viewHolder.LevelOneViewholder
import uk.co.chrisjenx.calligraphy.CalligraphyConfig
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper

class Level1Activity : AppCompatActivity() {
    internal lateinit var listCategory: RecyclerView
    internal lateinit var adapter: FirebaseRecyclerAdapter<LevelOne, LevelOneViewholder>
    internal lateinit var shimmerLayout: ShimmerLayout
    internal lateinit var database: FirebaseDatabase
    internal lateinit var categories: DatabaseReference

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        CalligraphyConfig.initDefault(
            CalligraphyConfig.Builder()
                .setDefaultFontPath("fonts/MontserratAlternates-Bold.otf")
                .setFontAttrId(R.attr.fontPath)
                .build()
        )
        setContentView(R.layout.activity_level1)
        shimmerLayout = findViewById(R.id.shimmerLayout)
        database = FirebaseDatabase.getInstance()
        categories = database.getReference("Levelone")


        listCategory = findViewById(R.id.listCategory)

        listCategory.layoutManager = LinearLayoutManager(this)

        loadCategories()
    }

    private fun loadCategories() {
        shimmerLayout.startShimmerAnimation()

        adapter = object : FirebaseRecyclerAdapter<LevelOne, LevelOneViewholder>(
            LevelOne::class.java,
            R.layout.level1_item,
            LevelOneViewholder::class.java,
            categories
        ) {
            override fun populateViewHolder(viewHolder: LevelOneViewholder, model: LevelOne, position: Int) {


                Picasso.with(this@Level1Activity)
                    .load(model.Image)
                    .into(viewHolder.category_image)


                viewHolder.setItemClickListener(object : ItemClickListener {
                    override fun onClick(view: View, position: Int, isLongClick: Boolean) {
                        val startGame = Intent(this@Level1Activity, StartOneActivity::class.java)
                        Common.categoryId = adapter.getRef(position).key
                        startActivity(startGame)


                    }

                })
                shimmerLayout.stopShimmerAnimation()
                shimmerLayout.visibility = View.GONE
            }


        }


        adapter.notifyDataSetChanged()
        listCategory.adapter = adapter

    }


    override fun attachBaseContext(newBase: Context) {
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase))
    }

    fun back(v: View?){
        onBackPressed()
    }
}
