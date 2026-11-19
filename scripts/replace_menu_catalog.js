const { PrismaClient } = require("../node_modules/@prisma/client");
const crypto = require("crypto");

const RAW_CSV = `CategoryName,ItemName,ItemShortCode,ItemDescription,OnlineDisplayName,ItemBasePrice,Dietary,Parcel,Available,Zomato,Available,Swiggy,Available
Pizza (Puff Pastry Base),Margherita Pizza,250,,Margherita Pizza,179,veg,189,Yes,235.75,Yes,235.75,Yes
Pizza (Puff Pastry Base),Veg Supreme Pizza,251,,Veg Supreme Pizza,239,veg,249,Yes,307.05,Yes,307.05,Yes
Pizza (Puff Pastry Base),Paneer Tikka Pizza,252,,Paneer Tikka Pizza,269,veg,279,Yes,345,Yes,345,Yes
Pizza (Puff Pastry Base),Spicy Veg Pizza,253,,Spicy Veg Pizza,199,veg,209,Yes,251.85,Yes,251.85,Yes
Pizza (Pizza Base),Margherita (pizza Base),371,,margherita (Pizza Base),209,veg,219,Yes,258.75,Yes,258.75,Yes
Pizza (Pizza Base),Veg Supreme (pizza Base),372,,veg supreme (Pizza Base),269,veg,279,Yes,330.05,Yes,330.05,Yes
Pizza (Pizza Base),Paneer Tikka  (pizza Base),373,,paneer tikka (Pizza Base),299,veg,309,Yes,368,Yes,368,Yes
Pizza (Pizza Base),Spicy Veg (pizza Base),374,,spicy veg (Pizza Base),229,veg,239,Yes,274.85,Yes,274.85,Yes
Thick Shakes,Biscoff Thickshake,400,,,210,veg,220,Yes,276,Yes,276,Yes
Thick Shakes,Choco Brownie Crumble,399,,,210,veg,220,Yes,276,Yes,276,Yes
Thick Shakes,Oreo Nutella,398,,,210,veg,220,Yes,276,Yes,276,Yes
Thick Shakes,Crunchy Butterscotch,397,,crunchy butterscotch,210,veg,220,Yes,276,Yes,276,Yes
Thick Shakes,Mango Blast (seasonal),490,,,200,veg,210,Yes,276,No,276,No
Thick Shakes,Sharjah Thickshake,406,,,210,veg,220,Yes,276,Yes,276,Yes
Thick Shakes,Rose Gulkand Thick Shake,thik shake,,,200,veg,200,No,230,No,230,No
Thick Shakes,Kitkat Thik Shake,Kitkat,,,210,veg,220,Yes,241.5,No,241.5,No
Thick Shakes,Choco Chips Thick Shake,Choco Chipis,,,210,veg,220,Yes,241.5,No,241.5,No
Thick Shakes,Oreo Thick Shake,oreo,,,210,veg,220,Yes,241.5,No,241.5,No
Thick Shakes,Hazenult Thick Shake,Shake,,,210,veg,220,Yes,241.5,No,241.5,No
Thick Shakes,Orange Blast,Orange,,,200,veg,210,Yes,200,No,200,No
Milk Shakes,Cold Coffee,67,"Refreshing blend of chilled coffee and creamy goodness, perfect for a delightful treat on a hot day.",Cold Coffee,120,veg,130,Yes,166.75,Yes,166.75,Yes
Milk Shakes,Oreo Milk Shake,68,"A delicious beverage made using Oreo cookies, whole milk and vanilla ice cream.",Oreo Milkshake,120,veg,130,Yes,166.75,Yes,166.75,Yes
Milk Shakes,Kit Kat Milk Shake,70,"A luscious and creamy milkshake with a delightful twist, perfect for all chocolate lovers.",Kit Kat Milk Shake,130,veg,140,Yes,178.25,Yes,178.25,Yes
Milk Shakes,Choco Brownie Milk Shake,73,A rich and indulgent milkshake with a heavenly blend of chocolate and brownie flavors.,Choco Brownie Milk Shake,140,veg,150,Yes,189.75,Yes,189.75,Yes
Milk Shakes,Caramel Milk Shake,122,,Caramel Milk Shake,130,veg,140,Yes,178.25,Yes,178.25,Yes
Milk Shakes,Hazelnut Milk Shake,120,,Hazelnut Milk Shake,160,veg,170,Yes,218.5,Yes,218.5,Yes
Milk Shakes,Cold Coffee Strong,326,,,140,veg,150,Yes,193.2,No,193.2,No
Milk Shakes,Chocolate Milk Shake,654,,Chocolate Milk Shake,120,veg,130,No,165.6,Yes,165.6,Yes
Milk Shakes,Extra Brownie,1951,,,40,veg,40,Yes,55.2,No,55.2,No
Milk Shakes,Biscoff Milkshake,396,,Biscoff Milkshake,160,veg,170,Yes,220.8,Yes,220.8,Yes
Milk Shakes,Extra Vanilla,305,,,40,veg,40,Yes,55.2,No,55.2,No
Milk Shakes,Extra Oreo,402,,,30,veg,30,No,41.4,No,41.4,No
Milk Shakes,Rose Gulkand,1509,,Rose Gulkand,170,veg,180,Yes,172.5,Yes,172.5,Yes
Milk Shakes,Badam Milk,Badam,,,50,veg,60,Yes,57.5,No,57.5,No
Milk Shakes,Caramel Banana Milk Shake,Banana,,,120,veg,130,No,138,No,138,No
Mocktails,Jeera Masala,jeera masala,"Jeera [cumin seeds] is not only an effective digestive spice, it is also extremely popular. Jeera Masala Soda is a delicious refreshing summer drink.",Jeera Masala,120,veg,130,Yes,161,Yes,161,Yes
Mocktails,Mint Mojito,76,"[Non Alcoholic] If you're in the mood for a fun summer drink, this mint mojito is just what you need! It's refreshing and delicious.",Mint Mojito,120,veg,130,Yes,161,Yes,161,Yes
Mocktails,Fresh Lime Soda,112,,,80,veg,90,Yes,110.4,No,110.4,No
Mocktails,Water Melon Burst,258,,Water Melon Burst,120,veg,130,Yes,161,Yes,161,Yes
Mocktails,Exotic Pineapple,259,,Exotic Pineapple,120,veg,130,Yes,161,Yes,161,Yes
Mocktails,Kala Katta,260,,Kala Katta,120,veg,130,Yes,161,Yes,161,Yes
Mocktails,Lychee Dream Delight,261,,Lychee Dream Delight,120,veg,130,Yes,161,Yes,161,Yes
Mocktails,Ginger Lime Sparkler,262,,Ginger Lime Sparkler,120,veg,130,Yes,161,Yes,161,Yes
Mocktails,Blue Lagoon,455,,Blue Lagoon,120,veg,120,Yes,161,Yes,161,Yes
Mocktails,Virgin Mojito,508,,Virgin Mojito,120,veg,130,Yes,161,Yes,161,Yes
Falooda,Classic Falooda,classic falooda,Indulge in the lusciousness of this irresistible Falooda Milk Shake.,Classic Falooda,130,veg,140,Yes,178.25,Yes,178.25,Yes
Falooda,Classic Falooda (half),111,,classic falooda (half),80,veg,80,No,92,No,92,No
Falooda,Kulfi Faluda,kulfi faluda,,Kulfi Falooda,160,veg,170,Yes,218.5,Yes,218.5,Yes
Falooda,Kulfi Faluda Half,384,,,120,veg,120,No,165.6,No,165.6,No
Falooda,Butterscotch Rabri Faluda,butter scotch rabri,,Butterscotch Rabri Falooda,150,veg,160,Yes,207,Yes,207,Yes
Falooda,Butter Scotch Rabri Faluda Half,386,,,110,veg,110,No,151.8,No,151.8,No
Falooda,Kulfi Faluda With Ice Cream (half),506,,,130,veg,140,Yes,179.4,No,179.4,No
Falooda,Kulfi Faluda With Ice Cream,kulfi faluda with ic,,Kulfi Falooda With Ice Cream,170,veg,180,Yes,234.6,Yes,234.6,Yes
Falooda,Mango Faluda (seasonal) Full,1506,,,180,veg,190,Yes,245,Yes,245,Yes
Falooda,Mango Faluda (seasonal) Half,1507,,,140,veg,140,Yes,151.8,No,151.8,No
Frankie,Manchurian Masti Frankie,178,"Indo-Chinese meets street food in this fiery fusion roll! Stuffed with juicy veg Manchurian balls dunked in spicy-tangy Manchurian sauce, and topped with vinegar-marinated onions and green chillies for that perfect sour crunch. A must-try for spice lovers and desi-Chinese fans alike!",,120,veg,130,Yes,184,Yes,184,Yes
Frankie,Schezwan Patakha Frankie,1748,"Crispy honey chilli potatoes tossed in fiery Schezwan sauce, drizzled with creamy Schezwan mayo, and wrapped in a soft, masala-loaded frankie roll. A perfect desi-Chinese explosion in every bite!",,120,veg,130,Yes,184,Yes,184,Yes
Frankie,Punjabi Blast Frankie,1749,"A bold fusion roll packed with spicy chole, layered with a crunchy surprise of crushed pani puri shells, and topped off with tangy vinegar-marinated onions and green chillies. Each bite is a riot of textures and street-style flavours — spicy, crunchy, and irresistibly chatpata!",,120,veg,130,Yes,184,Yes,184,Yes
Frankie,Kaaram Paneer Frankie,1762,"A rustic roll that packs a punch! Tender paneer cubes sautéed in fiery Telangana-style spices, wrapped up with a sharp-tangy mix of onion and green chillies marinated to perfection. Unapologetically local — this one's for the true spice lovers.",,120,veg,130,Yes,172.5,Yes,172.5,Yes
Frankie,Vellulli Paneer Punch Frankie,vellulli paneer punc,"A fiery favorite straight from Telugu kitchens! This roll is packed with sautéed paneer tossed in spicy vellulli karam (a robust garlic-red chilli spice blend), layered with tangy Onion-Chilli Relish. One bite, you'll feel the bold garlic punch and desi street food magic come alive!",,120,veg,130,Yes,184,Yes,184,Yes
Fries,Crispy Salted Fries,18,,Crispy Salted Fries,130,veg,140,Yes,172.5,Yes,172.5,Yes
Fries,Peri Peri Fries,20,"Crispy fries with a tantalizing, flavorful twist that will leave your taste buds wanting more.",Peri Peri Fries,140,veg,150,Yes,189.75,Yes,189.75,Yes
Fries,Animal Style Fries,278,,Animal Style Fries,169,veg,179,Yes,218.5,Yes,218.5,Yes
Fries,Paneer Popcorn,279,,Paneer Popcorn,219,veg,229,Yes,274.85,Yes,274.85,Yes
Fries,Extra Dip,281,,Extra Dip,30,veg,30,Yes,27.6,No,27.6,No
Fries,Karam Podi Fries,1406,,Karam Podi Fries,140,veg,150,Yes,184,Yes,184,Yes
Desserts,Vanilla Icecream With  Brownie,84,,Vanilla Icecream With  Brownie,120,veg,130,Yes,193.2,No,193.2,No
Desserts,Kulfi With Rabri,405,,Kulfi With Rabri,85,veg,95,No,117.3,No,117.3,No
Desserts,Mango Delight (seasonal),1510,,,150,veg,160,Yes,207,No,207,No
Desserts,Jamun Ka Ghosla,1607,,Jamun Ka Ghosla,140,veg,150,Yes,172.5,No,172.5,No
Desserts,Choco Brownie,choco brownie,,Choco Brownie,90,veg,100,Yes,126.5,Yes,126.5,Yes
Desserts,Kunafa,Kunafa,,,170,veg,180,Yes,195.5,No,195.5,No
Desserts,Kunafa Choco Dream,Dream,,,200,veg,200,Yes,310.5,Yes,310.5,Yes
Desserts,Death By Chocolate,Death,,,140,veg,150,Yes,120,No,120,No
Desserts,Fruit Overload,Fruit,,,120,veg,130,Yes,120,No,120,No
Desserts,Nutty Caramel,Nutty,,,140,veg,150,Yes,120,No,120,No
Desserts,Choco Lava Softy,choco,,,120,veg,130,No,120,No,120,No
Momos,Veg Fried Momos (10Pcs),56,,Veg Fried Momos (10Pcs),140,veg,150,Yes,193.2,Yes,193.2,Yes
Momos,Paneer Fried Momos (10pcs),57,"A snack that has become almost synonymous with Chinese cuisine, made of a plain flour cover filled with paneer and sauteed veggies. These vegetarian dumplings are so good on their own or with a side of spicy finger licking chutney.",Paneer Fried Momos,150,veg,160,Yes,207,Yes,207,Yes
Momos,Mix Veg Steam Momos (10Pcs),58,,Mix Veg Steam Momos (10Pcs),140,veg,150,Yes,193.2,Yes,193.2,Yes
Momos,Paneer Steam Momos (10Pcs),59,,Paneer Steam Momos (10Pcs),150,veg,160,Yes,207,Yes,207,Yes
Sandwich,Corn Chilli Cheese Sandwich,271,,,169,veg,179,Yes,218.5,Yes,218.5,Yes
Sandwich,Veg Sandwich,499,,,109,veg,119,Yes,149.5,Yes,149.5,Yes
Sandwich,Veg Grilled Sandwich,501,,,129,veg,139,Yes,172.5,Yes,172.5,Yes
Sandwich,Veg Cheese Grilled Sandwich,502,,,139,veg,149,Yes,189.75,Yes,189.75,Yes
Sandwich,Paneer Grilled Sandwich,504,,,159,veg,169,Yes,218.5,Yes,218.5,Yes
Sandwich,Paneer Cheese Grilled Sandwich,505,,,169,veg,179,Yes,230,Yes,230,Yes
Sandwich,Beetroot Paneer,963,,,180,veg,190,Yes,207,No,207,No
Burger,Veg Burger,14,"A delectable meatfree creation bursting with flavor and loaded with fresh, tasty ingredients.",Veg Burger,149,veg,159,Yes,205.85,Yes,205.85,Yes
Burger,Veg Burger With Cheese,veg burger with chee,A scrumptious vegetarian burger topped with melted cheese. Serves 1,Veg Burger With Cheese,169,veg,179,Yes,230,Yes,230,Yes
Burger,Paneer Burger,16,A scrumptious veggie burger featuring a deliciously balanced combination of flavors and textures.,Paneer Burger,199,veg,209,Yes,270.25,Yes,270.25,Yes
Burger,Paneer Burger With Cheese,paneer burger with c,Deliciously satisfying and packed with the flavors of paneer cheese and a perfectly grilled patty.,Paneer Burger With Cheese,219,veg,229,Yes,299,Yes,299,Yes
Burger,Extra Cheese,180,,,40,veg,40,Yes,34.5,No,34.5,No
Garlic Breads,Cheese Garlic Bread,cheese garlic bread,,Cheese Garlic Bread,180,veg,190,Yes,248.4,Yes,248.4,Yes
Garlic Breads,Spicy Supreme,spicy supreme,,Spicy Supreme,190,veg,200,Yes,262.2,Yes,262.2,Yes
Garlic Breads,Exotica,256,,Exotica,199,veg,209,Yes,274.85,Yes,274.85,Yes
Garlic Breads,Spicy Paneer,257,,Spicy Paneer,219,veg,229,Yes,302.45,Yes,302.45,Yes
Pasta,Alfredo Pasta,276,,Alfredo Pasta,199,veg,209,Yes,274.85,Yes,274.85,Yes
Pasta,Arrabiata Pasta,277,,Arrabiata Pasta,219,veg,229,Yes,302.45,Yes,302.45,Yes
Chinese Starters,Veg Manchuria,50,"A tasty Indo Chinese dish of fried veggie balls in a spicy, sweet and tangy sauce.",Veg Manchurian,140,veg,150,Yes,193.2,Yes,193.2,Yes
Chinese Starters,Honey Chilli Potato,51,"A hugely popular Chinese dish, honey chilli potato is juicy, crunchy and full of flavour snack that you just cannot resist.",Honey Chilli Potato,150,veg,160,Yes,207,Yes,207,Yes
Chinese Starters,Paneer Majestic,52,"Paneer strips lightly coated with a smooth and silky yellow batter, deep fried until golden and then tossed in aromatic spice tadka and finally coated with the rich creamy majestic yellow color sauce",Paneer Majestic,175,veg,185,Yes,241.5,Yes,241.5,Yes
Chinese Starters,Veg Spring Rolls (6 Pcs),53,A traditional Chinese savory snack where a pastry sheet is filled with vegetables.,Veg Spring Roll,145,veg,155,Yes,200.1,Yes,200.1,Yes
Chinese Starters,Paneer 65,54,,Paneer 65,165,veg,175,Yes,230,Yes,230,Yes
Chinese Starters,Chilli Paneer,55,,Chilli Paneer,165,veg,175,Yes,230,Yes,230,Yes
Chinese Starters,Crispy Corn,129,,,160,veg,170,Yes,220.8,No,220.8,No
Chinese Starters,Rampuri Paneer,130,,Rampuri Paneer,180,veg,190,Yes,262.2,Yes,262.2,Yes
Chinese Starters,Garlic Paneer,411,,,175,veg,185,Yes,241.5,Yes,241.5,Yes
Chinese Starters,Chinese Bhel,387,,Chinese Bhel,150,veg,160,Yes,207,No,207,No
Chinese Starters,Manchaov Soup,176,,,99,veg,99,No,113.85,No,113.85,No
Chinese Starters,Lemoncoriender Soup,LEON,,,99,veg,99,No,126.5,No,126.5,No
Fried Rice,Veg Fried Rice,60,Asian dish made by stir frying cooked rice in a wok with vegetables and soya sauce.,Veg Fried Rice,140,veg,150,Yes,193.2,Yes,193.2,Yes
Fried Rice,Schezwan Fried Rice,61,"Unlike the regular fried rice, schezwan fried rice is hot and spicy with bursting flavours of ginger, garlic, soya sauce and red chilli paste",Schezwan Fried Rice,150,veg,160,Yes,207,Yes,207,Yes
Fried Rice,Burnt Garlic Rice,62,"A popular and tasty Indo Chinese fried rice dish made with basmati rice, mix vegetables, soy sauce, pepper and lots of garlic.",Burnt Garlic Rice,160,veg,170,Yes,220.8,Yes,220.8,Yes
Fried Rice,Garlic Fried Rice,63,"Hot garlic rice is a variation to the basic veg fried rice from the Indo Chinese cuisine. It turns out aromatic, mildly hot, spicy and delicious.",Garlic Fried Rice,160,veg,170,Yes,220.8,Yes,220.8,Yes
Fried Rice,Manchurian Fried Rice,412,,,180,veg,190,Yes,248.4,Yes,248.4,Yes
Fried Rice,Extra Schezwan Sauce,510,,,30,veg,30,Yes,41.4,No,41.4,No
Fried Rice,Schezwan Panner Fried Rice,pannerfried rice,,,180,veg,190,Yes,180,No,180,No
Noodles,Hakka Noodles,64,,Veg Hakka Noodles,130,veg,140,Yes,179.4,Yes,179.4,Yes
Noodles,Schezwan Noodles,65,,Schezwan Noodles,150,veg,160,Yes,207,Yes,207,Yes
Noodles,Schezwan Paneer Noodles,66,,Schezwan Paneer Noodles,180,veg,190,Yes,248.4,Yes,248.4,Yes
Noodles,Manchurian Noodles,413,,,160,veg,170,Yes,220.8,Yes,220.8,Yes
Dosa,Ghee Podi Dosa,38,"A tantalizing blend of flavors and textures, this veggie delight is perfect for those seeking a savory and satisfying Dosa Menu option.",Ghee Podi Dosa,120,veg,130,Yes,166.75,Yes,166.75,Yes
Dosa,Mysore Masala Dosa,39,A flavorful dosa with a savory filling. Serves 1,Mysore Masala Dosa,140,veg,150,Yes,189.75,Yes,189.75,Yes
Dosa,Pizza Dosa,40,This fusion of Italian and South Indian cuisine is going to turn heads. Crispy dosa with melted cheese.,Pizza Dosa,160,veg,170,Yes,218.5,Yes,218.5,Yes
Dosa,Paneer Butter Masala Dosa,41,Delight in the perfect blend of flavors and smooth texture in our mouthwatering butter-infused Paneer Masala Dosa.,Paneer Butter Masala Dosa,160,veg,170,Yes,218.5,Yes,218.5,Yes
Dosa,Palak Paneer Dosa,42,A delectable fusion of spinach and creamy paneer served with a crispy and savory dosa.,Palak Paneer Dosa,160,veg,170,Yes,218.5,Yes,218.5,Yes
Dosa,Manchurian Dosa,43,A savory and flavorful fusion of Chinese and South Indian cuisine that will tantalize your taste buds.,Manchurian Dosa,180,veg,190,Yes,230,Yes,230,Yes
Dosa,Pav Bhaji Dosa,44,"A delectable fusion of two iconic Indian dishes, this flavorful dosa will take your taste buds on a delightful culinary journey.",Pav Bhaji Dosa,180,veg,190,Yes,230,Yes,230,Yes
Dosa,Chocolate (nutella) Dosa,46,"Indulge in the ultimate sweet treat with this irresistible delight, blending the rich flavors of chocolate and Nutella in a heavenly, crispy dosa that kids will absolutely adore.",Chocolate Dosa,150,veg,160,Yes,207,Yes,207,Yes
Dosa,Ghee Dosa,209,,Ghee Dosa,120,veg,130,Yes,161,Yes,161,Yes
Dosa,Ghee Karivepaku Podi Dosa,355,,Ghee Karivepaku Podi Dosa,120,veg,130,Yes,161,Yes,161,Yes
Dosa,Vellulli Karam Dosa,409,,Vellulli Karam Dosa,120,veg,130,Yes,161,Yes,161,Yes
Dosa,Plain Dosa,410,,,80,veg,90,Yes,110.4,No,110.4,No
Dosa,Extra Aloo Masala,415,,,30,veg,30,Yes,41.4,No,41.4,No
Chat,Pani Puri (6 Pcs) (atta),21,,Atta Pani Poori [6 Pieces],40,veg,50,Yes,55.2,Yes,55.2,Yes
Chat,Pani Puri (6 Pcs) (suji),22,,Suji Pani Poori [6 Pieces],40,veg,50,Yes,55.2,Yes,55.2,Yes
Chat,Bhel Puri,23,A savory and crunchy mix of flavors that will leave you wanting more. Serves 1,Bhel Puri,90,veg,100,Yes,124.2,Yes,124.2,Yes
Chat,Dhai Puri (6 Pcs),24,Tantalizing bites of crunchy puri filled with savory goodness. Serves 1,Dahi Puri [6 Pieces],110,veg,120,Yes,151.8,Yes,151.8,Yes
Chat,Sev Puri,25,"A delightful combination of crispy puris, tangy chutney, and an array of savory toppings that promises to tantalize your taste buds.",Sev Puri,90,veg,100,Yes,124.2,Yes,124.2,Yes
Chat,Ragada Tikki Chat,26,"A delectable blend of flavors and textures, this vegetarian Chaat Menu delight promises a tantalizing burst of mouthwatering goodness.",Ragada Tikki Chaat,80,veg,90,Yes,110.4,Yes,110.4,Yes
Chat,Alu Tikki Chat,27,A flavorful and savory treat from the vibrant Chaat Menu that brings together the best of Indian spices and fresh ingredients.,Aloo Tikki Chaat,95,veg,105,Yes,131.1,Yes,131.1,Yes
Chat,Bhalla Papdi,28,"A delightful vegetarian Chaat creation that combines the goodness of Bhalla and crunchiness of Papdi, tantalizing your taste buds.",Bhalla Papadi,80,veg,90,Yes,110.4,Yes,110.4,Yes
Chat,Chole Bhature,29,The union of chickpea curry and fried flat bread.,Chole Bhature,130,veg,140,Yes,179.4,Yes,179.4,Yes
Chat,Dhai Bhalla,30,A refreshing and delightful vegetarian dish bursting with flavors from the Chaat Menu.,Dhai Bhalla,115,veg,125,Yes,158.7,Yes,158.7,Yes
Chat,Raj Kachori,31,Delight in the iconic flavors of this delectable vegetarian chaat that will leave your taste buds craving for more.,Raj Kachori,110,veg,120,Yes,151.8,Yes,151.8,Yes
Chat,Samosa Ragada,32,,Samosa Ragada,90,veg,100,Yes,124.2,Yes,124.2,Yes
Chat,Butter Pav Bhaji,33,"A hearty, delightsome, flavorful meal of mashed vegetable gravy with fluffy soft buttery pav, served with a side of crunchy onions and a lemon wedge.",Butter Pav Bhaji,120,veg,130,Yes,165.6,Yes,165.6,Yes
Chat,Cheese Pav Bhaji,34,"Indulge in a delectable blend of gooey cheese and flavorful spices, creating a tantalizing taste experience of pure bliss.",Cheese Pav Bhaji,130,veg,140,Yes,179.4,Yes,179.4,Yes
Chat,Paneer Pav Bhaji,35,"A vegetarian chaat that is savory, satisfying, and sure to delight your taste buds. Serves 1",Paneer Pav Bhaji,130,veg,140,Yes,179.4,Yes,179.4,Yes
Chat,Tawa Pulao,36,A popular and spicy street style pulao made with long grain rice and chefs special masala.,Tawa Pulao,125,veg,135,Yes,209,Yes,209,Yes
Chat,Extra Pav (2pc),109,,Extra Pav [2 Pav],50,veg,60,Yes,69,No,69,No
Chat,Extra Bathure,110,,Extra Bathure,50,veg,60,Yes,69,No,69,No
Chat,Apricot Delight,121,,Apricot Delight,120,veg,130,Yes,166.75,Yes,166.75,Yes
Chat,Dahi Samosa Chat,207,,,120,veg,130,Yes,165.6,Yes,165.6,Yes
Chat,Samosa Chole  Chat,samosa chole  chat,,Samosa Chole  Chat,100,veg,110,Yes,138,Yes,138,Yes
Chat,Dhai Papdi Chat,300,,,110,veg,120,Yes,151.8,Yes,151.8,Yes
Chat,Pani Puri Live,414,,,35,veg,0,No,48.3,No,48.3,No
Chat,Extra Chole,712,,,70,veg,80,Yes,80.5,No,80.5,No
Chat,Extra Raita,713,,,20,veg,20,Yes,23,No,23,No
Chat,Extra Bhaji,445,,,70,veg,70,Yes,80.5,No,80.5,No
Softy,Vanilla Softy,379,,,45,veg,45,No,54,No,54,No
Softy,Chocolate Softy,380,,,60,veg,60,No,72,No,72,No
Softy,Mix Softy,381,,,60,veg,60,No,72,No,72,No
Softy,Butter Stoch Softy,179,,,70,veg,70,No,70,No,70,No
Softy,Strawberry Softy,182,,,60,veg,60,No,60,No,60,No
Softy,Softy Cone,444,,,15,veg,15,No,10,No,10,No
Softy,South Indian Filter Softy,Filter Softy,,,60,veg,60,No,60,No,60,No
Parcel,Packing,125,,,10,veg,10,Yes,12,No,12,No
Tandoor,Paneer Tikka,47,,Paneer Tikka,249,veg,259,Yes,343.85,No,343.85,No
Tandoor,Mushroom Tikka,48,,Mushroom Tikka,239,veg,249,Yes,330.05,No,330.05,No
Tandoor,Veg Seekh Kabab,49,,Veg Seekh Kabab,249,veg,259,Yes,343.85,No,343.85,No
Beverges ,Water 500 Ml,106,,water 500 ml,10,veg,10,Yes,12,No,12,No
CHINESE STATERS NI,Hot & Sour Soup,354,,,99,veg,99,No,136.85,No,136.85,No
CHINESE STATERS NI,Tomato Soup,soup,,,100,veg,100,No,115,No,115,No
COMBO,Jalpan Chat Adda,JCA,,,429,veg,429,No,429,No,429,No
COMBO,Dosa Chill Combo,DCC,,,369,veg,369,No,369,No,369,No
COMBO,Chinese Hangout Combo,CHC,,,479,veg,479,No,479,No,479,No
COMBO,Burger Snack Combo,BSC,,,449,veg,449,No,449,No,449,No
COMBO,69 Upgrade,69,,,69,veg,69,No,69,No,69,No
COMBO,99 Upgrade,99,,,99,veg,99,No,99,No,99,No
COMBO,129 Upgrade,129 U,,,129,veg,129,No,129,No,129,No
Cookies,Coconut Biscuits 200gm,COCO b,,,150,veg,150,Yes,150,No,150,No
Cookies,Chocolate Biscuits 200gm,Ch B,,,150,veg,150,Yes,150,No,150,No
Cookies,Whole Wheat Biscuits 200gm,WWB,,,150,veg,150,Yes,150,No,150,No
Cookies,Salted Cookie 200gm,salted,,,150,veg,150,Yes,150,No,150,No`;

function parseCsvLine(line) {
  const result = [];
  let current = "";
  let inQuotes = false;
  for (let i = 0; i < line.length; i++) {
    const ch = line[i];
    if (ch === '"') {
      if (inQuotes && line[i + 1] === '"') {
        current += '"';
        i++;
      } else {
        inQuotes = !inQuotes;
      }
    } else if (ch === "," && !inQuotes) {
      result.push(current);
      current = "";
    } else {
      current += ch;
    }
  }
  result.push(current);
  return result.map((s) => s.trim());
}

function toMinor(val) {
  const num = parseFloat(val);
  if (isNaN(num) || num < 0) return 0n;
  return BigInt(Math.round(num * 100));
}

function toBool(val) {
  return String(val || "").trim().toLowerCase() === "yes";
}

async function main() {
  const prisma = new PrismaClient();
  try {
    const lines = RAW_CSV.split(/\r?\n/).filter((l) => l.trim().length > 0);
    const dataLines = lines.slice(1); // skip header
    const parsedItems = dataLines.map((line) => {
      const cols = parseCsvLine(line);
      return {
        categoryName: cols[0].trim(),
        itemName: cols[1].replace(/\s+/g, " ").trim(),
        shortCode: cols[2] || null,
        description: cols[3] || null,
        onlineDisplayName: cols[4] || null,
        basePriceMinor: toMinor(cols[5]),
        isVeg: String(cols[6] || "veg").toLowerCase() !== "non-veg",
        parcelPriceMinor: toMinor(cols[7]),
        parcelAvailable: toBool(cols[8]),
        zomatoPriceMinor: toMinor(cols[9]),
        zomatoAvailable: toBool(cols[10]),
        swiggyPriceMinor: toMinor(cols[11]),
        swiggyAvailable: toBool(cols[12]),
      };
    });

    console.log(`Parsed ${parsedItems.length} items from CSV.`);

    const outlets = await prisma.outlet.findMany({ select: { id: true, name: true } });
    console.log(`Updating menu catalog for ${outlets.length} outlets...`);

    const categoryOrder = [];
    const seenCats = new Set();
    for (const it of parsedItems) {
      if (!seenCats.has(it.categoryName)) {
        seenCats.add(it.categoryName);
        categoryOrder.push(it.categoryName);
      }
    }

    for (const outlet of outlets) {
      const outletId = outlet.id;

      // 1. Soft-deactivate all previous categories & items so old orders/KOTs remain intact
      await prisma.$executeRaw`UPDATE menu_items SET is_active = false, updated_at = NOW() WHERE outlet_id = ${outletId}::uuid`;
      await prisma.$executeRaw`UPDATE menu_categories SET is_active = false, updated_at = NOW() WHERE outlet_id = ${outletId}::uuid`;

      // 2. Upsert the new categories in exact CSV order
      const catIdByName = new Map();
      for (let idx = 0; idx < categoryOrder.length; idx++) {
        const catName = categoryOrder[idx];
        const existing = await prisma.menuCategory.findFirst({
          where: { outletId, name: catName },
        });
        if (existing) {
          await prisma.menuCategory.update({
            where: { id: existing.id },
            data: { isActive: true, sortOrder: idx + 1 },
          });
          catIdByName.set(catName, existing.id);
        } else {
          const created = await prisma.menuCategory.create({
            data: { outletId, name: catName, sortOrder: idx + 1, isActive: true },
          });
          catIdByName.set(catName, created.id);
        }
      }

      // 3. Upsert every new menu item with Dine-In, Parcel, Zomato & Swiggy prices
      let insertedCount = 0;
      let updatedCount = 0;
      for (const it of parsedItems) {
        const categoryId = catIdByName.get(it.categoryName);
        const existing = await prisma.menuItem.findFirst({
          where: { outletId, categoryId, name: it.itemName },
        });

        let itemId;
        if (existing) {
          itemId = existing.id;
          await prisma.$executeRaw`
            UPDATE menu_items
            SET
              description = ${it.description},
              online_display_name = ${it.onlineDisplayName},
              short_code = ${it.shortCode},
              price = ${it.basePriceMinor},
              tax_rate = 5.00,
              is_veg = ${it.isVeg},
              is_active = true,
              parcel_price = ${it.parcelPriceMinor},
              parcel_available = ${it.parcelAvailable},
              zomato_price = ${it.zomatoPriceMinor},
              zomato_available = ${it.zomatoAvailable},
              swiggy_price = ${it.swiggyPriceMinor},
              swiggy_available = ${it.swiggyAvailable},
              updated_at = NOW()
            WHERE id = ${itemId}::uuid
          `;
          updatedCount++;
        } else {
          itemId = crypto.randomUUID();
          await prisma.$executeRaw`
            INSERT INTO menu_items (
              id, outlet_id, category_id, name, description, online_display_name,
              short_code, price, tax_rate, is_veg, is_active,
              parcel_price, parcel_available, zomato_price, zomato_available,
              swiggy_price, swiggy_available, created_at, updated_at
            ) VALUES (
              ${itemId}::uuid, ${outletId}::uuid, ${categoryId}::uuid,
              ${it.itemName}, ${it.description}, ${it.onlineDisplayName},
              ${it.shortCode}, ${it.basePriceMinor}, 5.00, ${it.isVeg}, true,
              ${it.parcelPriceMinor}, ${it.parcelAvailable},
              ${it.zomatoPriceMinor}, ${it.zomatoAvailable},
              ${it.swiggyPriceMinor}, ${it.swiggyAvailable},
              NOW(), NOW()
            )
          `;
          insertedCount++;
        }

        // Ensure item_availability is ON & stocked
        await prisma.$executeRaw`
          INSERT INTO item_availability (id, outlet_id, item_id, state, version, stock_qty, updated_at)
          VALUES (gen_random_uuid(), ${outletId}::uuid, ${itemId}::uuid, 'ON'::availability_state, 1, 100, NOW())
          ON CONFLICT (outlet_id, item_id)
          DO UPDATE SET state = 'ON'::availability_state, stock_qty = 100, updated_at = NOW()
        `.catch(() => {});
      }

      console.log(
        `Outlet ${outlet.name} (${outletId}): ${categoryOrder.length} categories, ${insertedCount} inserted, ${updatedCount} updated.`
      );
    }
  } finally {
    await prisma.$disconnect();
  }
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
