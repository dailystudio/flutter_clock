# Digital Clock - Matrix Text Streams

This Flutter application is a digital clock powered with Matrix text streams effects.

![](./digital_clock.jpg)

# Layout
The main layout of this digital clock is built with following three main parts. Each part is highlighted with an orange frame.

![](./layout.png)

1. Dynamic Background
> A live background uses characters matrix to construct an image. The image represenet an event of the date. Basically, it will represent the constellation of the current date. 

2. Text Streams
> Text streams drop from the top of the screen to the bottom, the same effect as the moive Matrix. The character in each stream are selected randomly and the speed of each stream is also various. All of the streams will be reset once every minute.

3. Side Display
> Rest of useful information is enclosed in this part, including time, date, weatcher, temparture and location.

# Events
Currently, the dynamic background supports the following events:

Event Name       | Event Type | Date
:--:                 | :-:        | :-:
Aries                | Horoscope  | Mar. 21 - Arp. 19
Taurus               | Horoscope  | Apr. 20 - May 20
Gemini               | Horoscope  | May 21 - Jun. 20
Cancer               | Horoscope  | Jun. 21 - Jul. 22
Leo                  | Horoscope  | Jul. 23 - Aug. 22
Virgo                | Horoscope  | Aug. 23 - Sep. 22
Libra                | Horoscope  | Sep. 23 - Oct. 22
Scorpio              | Horoscope  | Oct. 23 - Nov. 21
Sagittarius          | Horoscope  | Nov. 22 - Dec. 21
Capricorn            | Horoscope  | Dec. 22 - Jan. 19
Aquarius             | Horoscope  | Jan. 20 - Feb. 18
Pisces               | Horoscope  | Feb. 19 - Mar. 20
Valentine's Day      | Festival   | Feb. 14
Saint Patrick's Day  | Festival   | Mar. 17
Halloween            | Festival   | Oct. 31
Christmas            | Festival   | Nov. 24 - Nov. 25
New Year             | Festival   | Dec. 31

The definition of events are described in the file **assets/events.json**. You can modify that file to support more events.

# Images

### Event Image
The image file for the dynamic background should be stored in PNG format with resolution 60 x36. The area, which has a 39 x 36 grid, on the left side will be the safe area. The content in this area will not be overlapped by the side display. Here is a concrete sample:

![](./event_image.png)

In the image, points with **transparent color** (#0000000000) will be mapped to black space on the clock face. The rest points will be filled with random characters on the screen.



### License
All the images under **assets/images** are published under Attribution 3.0 Unported (CC BY 3.0).

#### Attribution:


Files | Author | Link
:--:      | :-:    | :-:
horoscope/* | Chamestudio Pvt Ltd | [https://www.iconfinder.com/iconsets/astronomical-signs](https://www.iconfinder.com/iconsets/astronomical-signs)
weather/* | Fatkhul Karim | [https://www.iconfinder.com/iconsets/weather-line-19](https://www.iconfinder.com/iconsets/weather-line-19)
festival/christmas.png | Squarecup LTD | [https://www.iconfinder.com/iconsets/christmas-2442](https://www.iconfinder.com/iconsets/christmas-2442)
festival/halloween.png | Ionescu Georgiana Lavinia | [https://www.iconfinder.com/iconsets/vegetables-56](https://www.iconfinder.com/iconsets/vegetables-56)
festival/new_year.png | Becris . |[https://www.iconfinder.com/iconsets/chinese-new-year-4](https://www.iconfinder.com/iconsets/chinese-new-year-4)
festival/st\_patrick\_day.png | Alpár-Etele Méder | [https://www.iconfinder.com/icons/3017878/clover_day_patrick_st_icon](https://www.iconfinder.com/icons/3017878/clover_day_patrick_st_icon)
festival/valentine.png | Royyan Wijaya | [https://www.iconfinder.com/iconsets/gradak-interface](https://www.iconfinder.com/iconsets/gradak-interface)
