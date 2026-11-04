package net.sijawa.activity

import android.app.Activity
import android.content.Context
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.RecyclerView
import android.support.v7.widget.SearchView
import android.text.Editable
import android.text.TextWatcher
import android.view.View
import com.google.firebase.database.*
import kotlinx.android.synthetic.main.activity_peribahasa.*
import net.sijawa.R
import net.sijawa.adapter.PeribahasaAdapter
import net.sijawa.model.Peribahasa
import uk.co.chrisjenx.calligraphy.CalligraphyConfig
import uk.co.chrisjenx.calligraphy.CalligraphyContextWrapper
import java.nio.file.Files.size
import android.text.method.TextKeyListener.clear
import android.content.Intent
import android.widget.*
import com.firebase.ui.database.FirebaseRecyclerAdapter
import com.squareup.picasso.Picasso
import kotlinx.android.synthetic.main.item_does.view.*
import kotlinx.android.synthetic.main.item_does.view.titledoes
import kotlinx.android.synthetic.main.item_peribahasa.view.*
import java.util.ArrayList

class PeribahasaActivity : AppCompatActivity() {

    lateinit var mSearchText : EditText
    lateinit var mRecyclerView : RecyclerView
    internal lateinit var list: ArrayList<Peribahasa>
    internal lateinit var peribahasaAdapter: PeribahasaAdapter
    lateinit var mDatabase : DatabaseReference


    lateinit var FirebaseRecyclerAdapter : FirebaseRecyclerAdapter<Peribahasa , UsersViewHolder>

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        CalligraphyConfig.initDefault(
            CalligraphyConfig.Builder()
                .setDefaultFontPath("fonts/MontserratAlternates-Bold.otf")
                .setFontAttrId(R.attr.fontPath)
                .build()
        )
        setContentView(R.layout.activity_peribahasa)

        mSearchText =findViewById(R.id.search)
        mRecyclerView = findViewById(R.id.ourdoes)

        mRecyclerView.setHasFixedSize(true)
        mRecyclerView.layoutManager = LinearLayoutManager(this)
        list = ArrayList<Peribahasa>()


        mDatabase = FirebaseDatabase.getInstance().reference.child("Peribahasa")
        // get data from firebase

       loadFirst()



        mSearchText.addTextChangedListener(object  : TextWatcher {
            override fun afterTextChanged(p0: Editable?) {


            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
                val searchText = mSearchText.getText().toString().trim()
                loadFirebaseData(searchText)

            }
        } )

    }

    private fun loadFirst() {
        mDatabase.addValueEventListener(object : ValueEventListener {
            override fun onDataChange(dataSnapshot: DataSnapshot) {
                // set code to retrive data and replace layout
                for (dataSnapshot1 in dataSnapshot.children) {
                    val p = dataSnapshot1.getValue<Peribahasa>(Peribahasa::class.java)
                    list.add(p!!)
                }
                peribahasaAdapter = PeribahasaAdapter(this@PeribahasaActivity, list)
                ourdoes.adapter = peribahasaAdapter
                peribahasaAdapter.notifyDataSetChanged()
            }

            override fun onCancelled(databaseError: DatabaseError) {
                // set code to show an error
                Toast.makeText(applicationContext, "No Data", Toast.LENGTH_SHORT).show()
            }
        })
    }

    private fun loadFirebaseData(searchText : String) {
        endpage.visibility = View.INVISIBLE



        if(searchText.isEmpty()){
            FirebaseRecyclerAdapter.cleanup()
            mRecyclerView.adapter = FirebaseRecyclerAdapter
            loadFirst()


        }else {

            val firebaseSearchQuery = mDatabase.orderByChild("paribasan").startAt(searchText).endAt(searchText + "\uf8ff")

            FirebaseRecyclerAdapter = object : FirebaseRecyclerAdapter<Peribahasa, UsersViewHolder>(

                Peribahasa::class.java,
                R.layout.item_peribahasa,
                UsersViewHolder::class.java,
                firebaseSearchQuery
            ) {
                override fun populateViewHolder(viewHolder: UsersViewHolder, model: Peribahasa?, position: Int) {
                    viewHolder.mview.titledoes.text = model?.paribasan
                    viewHolder.mview.titledoess.text = model?.arti_JW
                    viewHolder.mview.titledoesss.text = model?.arti_ID

                    val getParibasan = model?.paribasan
                    val getArtiId = model?.arti_ID
                    val getArtiJw = model?.arti_JW

                    viewHolder.mview.setOnClickListener {

                    }

                }

            }
            mRecyclerView.adapter = FirebaseRecyclerAdapter

        }
    }
    override fun attachBaseContext(newBase: Context) {
        super.attachBaseContext(CalligraphyContextWrapper.wrap(newBase))
    }

    fun back(v: View?){
        onBackPressed()
    }

    // // View Holder Class

    class UsersViewHolder(var mview : View) : RecyclerView.ViewHolder(mview) {

    }


}
