# Aegisub 오토메이션을 위한 Lua 5.1 스크립트
Aegisub 소프트웨어가 2014년 3.2.2 버전으로 진행한 마이너 업데이트 이후로 별다른 업데이트 소식을 내놓지는 않고 있습니다. Github에서 [Aegisub repository](https://github.com/Aegisub/Aegisub)가 만들어지고 많은 분들께서 기여해주고 계시긴 하지만, 3.2.2 버전 이후의 후속 버전이 나오기는 힘든 모양입니다.  
Aegisub의 기능적 개선은 힘들고, ASS 자막 포맷의 기능적 향상은 더욱 기대하기 힘든 상황에서 Lua 기반의 스크립트를 오토메이션으로 제공하는 점은 그나마 Aegisub과 ASS 포맷의 한 줄기 희망(?)인 것 같습니다. 물론, 기본으로 제공해도 될 법한 간단한 기능 역시 Aegisub이 자체적으로 기능을 개선해주지 않으면 Lua 스크립트로 제공해야 합니다.  
과거 한 때 짧은 오프닝, 엔딩 자막을 만들어 본 경험에서 꼭 필요하거나, 혹은 이런 기능이 있었으면 좋았을 기능들을 Lua 스크립트로 제공하고자 합니다.  
사실, 과거 블로그 포스트로 등록했던 스크립트가 있는데 OneDrive에서 공유하는 것 보다 Github에서 공유하는 것이 더 나을 것 같아 repository를 등록한 것이 직접적인 계기이긴 합니다.  

## 참고 사이트
프로젝트를 진행하면서 참고한 사이트들을 나열했습니다.  
*([Aegisub repository](https://github.com/Aegisub/Aegisub)에서 제공하는 devel.aegisub.org 사이트가 접속되지 않습니다.)*  

### Aegisub 공식 사이트 및 메뉴얼
 * [http://www.aegisub.org/](http://www.aegisub.org/)  
 * [http://docs.aegisub.org/3.2/Main_Page/](http://docs.aegisub.org/3.2/Main_Page/)  
 * [https://github.com/Aegisub/Aegisub](https://github.com/Aegisub/Aegisub)

### Lua 레퍼런스
 * [https://www.lua.org/manual/5.1/](https://www.lua.org/manual/5.1/)

## 문의
만일 이 repository나 Aegisub에 대한 문의가 있으시면, 아래 링크를 참고하여 연락을 취해주시면 좋겠습니다. 사실, 모든 문제를 해결해 드리기에는 제 그릇이 작아 함께 고민해보는 데 의의를 두셨으면 좋겠습니다.  

 * 이메일 : [gcyong@outlook.com](mailto:gcyong@outlook.com)  
 * 블로그 : [http://gcyong.tistory.com](http://gcyong.tistory.com)
