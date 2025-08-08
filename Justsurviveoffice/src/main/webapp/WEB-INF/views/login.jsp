<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
        <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
 <style>
        .kakao-bg {
            background-color: #FEE500;
        }
        .kakao-text {
            color: #3A1D1D;
        }
        .naver-bg {
            background-color: #03C75A;
        }
        .naver-text {
            color: white;
        }
        .divider {
            display: flex;
            align-items: center;
            text-align: center;
            color: #9CA3AF;
        }
        .divider::before,
        .divider::after {
            content: "";
            flex: 1;
            border-bottom: 1px solid #E5E7EB;
        }
        .divider:not(:empty)::before {
            margin-right: 1em;
        }
        .divider:not(:empty)::after {
            margin-left: 1em;
        }
        .input-focus:focus {
            border-color: #6366F1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
        }
    </style>
</head>
<body class="bg-gray-50 min-h-screen flex items-center justify-center p-4">
    <div class="bg-white rounded-xl shadow-lg overflow-hidden w-full max-w-md">
        <!--  헤더 섹션 -->
        <div class="bg-indigo-600 py-6 px-8 text-center">
            <h1 class="text-2xl font-bold text-white">로그인</h1>
            <p class="text-indigo-100 mt-1">계정에 로그인하세요</p>
        </div>
        
        <!-- 로그인 폼 -->
        <div class="p-8">
            <form class="space-y-6">
                <div>
                    <label for="email" class="block text-sm font-medium text-gray-700 mb-1">아이디</label>
                    <input type="email" id="email" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition input-focus" placeholder="example@example.com">
                </div>
                
                <div>
                    <label for="password" class="block text-sm font-medium text-gray-700 mb-1">비밀번호</label>
                    <input type="password" id="password" class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition input-focus" placeholder="••••••••">
                </div>
                
                <div class="flex items-center justify-between">
                    <div class="flex items-center">
                        <input id="remember-me" name="remember-me" type="checkbox" class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded">
                        <label for="remember-me" class="ml-2 block text-sm text-gray-700">로그인 상태 유지</label>
                    </div>
                    
                    <div class="text-sm">
                        <a href="#" class="font-medium text-indigo-600 hover:text-indigo-500">비밀번호 찾기</a>
                    </div>
                </div>
                
                <button type="submit" class="w-full flex justify-center py-3 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition">
                    로그인
                </button>
            </form>
            
            <!-- 소셜 로그인 구분선 -->
            <div class="mt-8">
                <div class="divider text-sm">소셜 계정으로 로그인</div>
            </div>
            
            <!-- 소셜 로그인 버튼 -->
            <div class="mt-6 grid grid-cols-2 gap-3">
                <!-- 카카오 로그인 버튼 -->
                <a href="#" class="w-full inline-flex justify-center py-3 px-4 rounded-md shadow-sm text-sm font-medium kakao-bg kakao-text hover:bg-yellow-400 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-yellow-500 transition">
                    <i class="fas fa-comment mr-2 text-lg"></i>
                    카카오 로그인
                </a>
                
                <!-- 네이버 로그인 버튼 -->
                <a href="#" class="w-full inline-flex justify-center py-3 px-4 rounded-md shadow-sm text-sm font-medium naver-bg naver-text hover:bg-green-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 transition">
                    <i class="fas fa-n mr-2 text-lg"></i>
                    네이버 로그인
                </a>
            </div>
            
            <!-- 회원가입 링크 -->
            <div class="mt-6 text-center">
                <p class="text-sm text-gray-600">
                    아직 회원이 아니신가요?
                    <a href="#" class="font-medium text-indigo-600 hover:text-indigo-500">회원가입</a>
                </p>
            </div>
        </div>
    </div>

    <script>
        // 카카오 로그인 버튼 클릭 시
        document.querySelector('.kakao-bg').addEventListener('click', function(e) {
            e.preventDefault();
            alert('카카오 로그인이 진행됩니다.');
            // 실제 구현 시에는 카카오 SDK를 사용한 로그인 프로세스 구현
        });

        // 네이버 로그인 버튼 클릭 시
        document.querySelector('.naver-bg').addEventListener('click', function(e) {
            e.preventDefault();
            alert('네이버 로그인이 진행됩니다.');
            // 실제 구현 시에는 네이버 SDK를 사용한 로그인 프로세스 구현
        });
    </script>