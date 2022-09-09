import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:juniorapp/ColorPalette.dart';
import 'package:juniorapp/Models/BlogItemModel.dart';
import 'package:juniorapp/Services/blogService.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(

    backgroundColor: Colors.white,
    title: Text("Blog",style: TextStyle(color: ColorPalette().blue,fontWeight: FontWeight.bold),),
    ),
      body: FutureBuilder(
        future: BlogService().getBlogs(),
        builder: ((context,AsyncSnapshot snap){
          if(!snap.hasData){
            return Center(child: Text("Loading...",style: TextStyle(color: Colors.black26,fontSize: 25),));
          }
         else{
           List<BlogItemModel> blogs = snap.data;
           return Column(
             children: [
               Expanded(
                 child: GridView.count(
                   ///GRIDVIEW.BUILDER
                   padding: EdgeInsets.all(20),
                   crossAxisSpacing: 10,
                   mainAxisSpacing: 10,
                   childAspectRatio: 0.6,
                   shrinkWrap: true,
                   crossAxisCount: 2,
                   children: createCards(context, blogs),
                 ),

               ),

             ],
           );
          }
        }),
      )
    );
  }

  List<Widget> createCards(BuildContext context, List<BlogItemModel> blogs){
    List<InkWell> cards = [];

    for (BlogItemModel blog in blogs){
      cards.add(InkWell(
        child: Card(
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height:MediaQuery.of(context).size.height*0.27,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(blog.imageLink),
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(blog.category,style: TextStyle(color: Colors.grey),),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0,right: 5),
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.1,
                    child: Text(blog.title,
                      style: TextStyle(
                          fontSize:18 ,
                          fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: ()async{
          BlogService().launchURL(blog.blogLinkHost,blog.blogLinkPath);
        },
      ));
    }

    return cards;
  }
}


/*Column(
        children: [
          Expanded(
            child: GridView.count(
///GRIDVIEW.BUILDER
              padding: EdgeInsets.all(20),
             crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.6,
              shrinkWrap: true,
                crossAxisCount: 2,
              children: [
                InkWell(
                  child: Card(
                      elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height:MediaQuery.of(context).size.height*0.27,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/juniorapp-99648.appspot.com/o/blogImages%2Fblog1.png?alt=media&token=32880df1-26c5-423c-83b6-3fb2a4e638ed'),
                        )
                      ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text("Seyahat",style: TextStyle(color: Colors.grey),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0,right: 5),
                        child: Container(
                          height: MediaQuery.of(context).size.height*0.1,
                          child: Text("ANTALYA'DA YAPILMADAN DÖNÜLMEYECEK ŞEYLER",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ),
                  onTap: ()async{
                  blogService().launchURL("senyor.app","/2022/04/06/antalyada-yapilmadan-donulmeyecek-seyler/");
                 },
                ),
                InkWell(
                  child: Card(
                      elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height:MediaQuery.of(context).size.height*0.27,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/juniorapp-99648.appspot.com/o/blogImages%2Fblog2.png?alt=media&token=21388d23-8ec5-470c-b71a-7002cb09f888'),
                        )
                      ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text("Eğlence",style: TextStyle(color: Colors.grey),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0,right: 5),
                        child: Container(
                          height: MediaQuery.of(context).size.height*0.1,
                          child: Text("Aşkın Güzelliği: 5 Çiftin Hikayesi",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ),
                  onTap: ()async{
                    blogService().launchURL("senyor.app","/2022/02/22/askin-guzelligi/");
                  },
                ),
                InkWell(
                  child: Card(
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height:MediaQuery.of(context).size.height*0.27,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/juniorapp-99648.appspot.com/o/blogImages%2Fblog3.png?alt=media&token=d8030a65-7d4a-4a0e-ae00-093701417447'),
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text("Teknoloji",style: TextStyle(color: Colors.grey),),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0,right: 5),
                            child: Container(
                              height: MediaQuery.of(context).size.height*0.1,
                              child: Text("Teknoloji İyi Bir Öğretmen Olabilir Mi?",
                                style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: ()async{
                    blogService().launchURL("senyor.app","/2022/02/03/teknoloji-ile-ogrenme/");
                  },
                ),
                InkWell(
                  child: Card(
                    elevation: 3,
                    child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height:MediaQuery.of(context).size.height*0.27,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/juniorapp-99648.appspot.com/o/blogImages%2Fblog4.png?alt=media&token=f1eaccd5-d353-4168-921f-9b3a54fa40c0'),
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text("Teknoloji",style: TextStyle(color: Colors.grey),),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0,right: 5),
                            child: Container(
                              height: MediaQuery.of(context).size.height*0.1,
                              child: Text("Gazeteleri Takip Edebileceğiniz Web Siteler ve Uygulamalar",
                                style: TextStyle(
                                fontSize:18 ,
                                fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: ()async{
                    blogService().launchURL("senyor.app","/2021/11/02/gazeteleri-takip-edebileceginiz-web-siteler-ve-uygulamalar/");
                  },
                ),
              ],
            ),

          ),

        ],
      ),*/