package net.sijawa.activity

import android.content.Context
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.view.View
import com.firebase.ui.database.FirebaseRecyclerAdapter
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import com.squareup.picasso.Picasso
import io.supercharge.shimmerlayout.ShimmerLayout
import net.sijawa.Interface.ItemClickListener
import net.sijawa.R
import net.sijawa.common.Common
import net.sijawa.common.Common3
import net.sijawa.model.LevelOne
import net.sijawa.model.LevelThree
import net.sijawa.viewHolder.LevelOneViewholder
import net.sijawa.viewHolder.LevelThreeViewHolder
import uk.co.chrisjenx.calligraphy.CalligraphyConfig
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper

class Level3Activity : AppCompatActivity() {
    internal lateinit var listCategory: RecyclerView
    internal lateinit var adapter: FirebaseRecyclerAdapter<LevelThree, LevelThreeViewHolder>
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
        setContentView(R.layout.activity_level3)
        shimmerLayout = findViewById(R.id.shimmerLayout)
        database = FirebaseDatabase.getInstance()
        categories = database.getReference("Levelthree")
        listCategory = findViewById(R.id.listCategory)
        listCategory.layoutManager = LinearLayoutManager(this)


        loadCategories()
    }

    private fun loadCategories() {
        shimmerLayout.startShimmerAnimation()
        adapter = object : FirebaseRecyclerAdapter<LevelThree, LevelThreeViewHolder>(
            LevelThree::class.java,
            R.layout.level1_item,
            LevelThreeViewHolder::class.java,
            categories
        ) {
            override fun populateViewHolder(viewHolder: LevelThreeViewHolder, model: LevelThree, position: Int) {
                Picasso.with(this@Level3Activity)
                    .load(model.Image)
                    .into(viewHolder.category_image)

                viewHolder.setItemClickListener(object : ItemClickListener {
                    override fun onClick(view: View, position: Int, isLongClick: Boolean) {
                        val startGame = Intent(this@Level3Activity, StartThreeActivity::class.java)
                        Common3.categoryId = adapter.getRef(position).key
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

