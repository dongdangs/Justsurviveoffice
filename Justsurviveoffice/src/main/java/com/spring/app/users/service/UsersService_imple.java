package com.spring.app.users.service;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;

import java.util.NoSuchElementException;
import java.util.Optional;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Service;

import com.spring.app.common.AES256;

import com.spring.app.common.SecretMyKey;

import com.spring.app.common.Sha256;
import com.spring.app.entity.LoginHistory;
import com.spring.app.entity.Users;
import com.spring.app.model.HistoryRepository;
import com.spring.app.model.UsersRepository;
import com.spring.app.users.domain.LoginHistoryDTO;
import com.spring.app.users.domain.UsersDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UsersService_imple implements UsersService {

   private final UsersRepository usersRepository;
   private final HistoryRepository historyRepository;

   private AES256 aes;

       

   @Override
   public UsersDTO getUser(String id, String Pwd) {
         
     UsersDTO usersDto = null;
         
     try {
        Optional<Users> user = usersRepository.findById(id);
   /*   Java8에서는 Optional<T> 클래스를 사용해 NullPointerException 을 방지할 수 있도록 도와준다. 
        Optional<T>는 null이 올 수 있는 값을 감싸는 Wrapper 클래스 이므로, 참조하더라도 NullPointerException 이 발생하지 않도록 도와준다. 
        Optional 클래스는 null 이더라도 바로 NullPointerException 이 발생하지 않으며, 클래스이기 때문에 각종 메소드를 제공해준다. */
        aes = new AES256(SecretMyKey.KEY);
        
        Users users = user.get();
        // java.util.Optional.get() 은 값이 존재하면 값을 리턴시켜주고, 값이 없으면 NoSuchElementException 을 유발시켜준다.
        
        
           try {
              usersDto = users.toDTO();
              System.out.println(usersDto.getId());
              System.out.println(Sha256.encrypt(Pwd));
              // usersDto.setPassword(Sha256.encrypt(Pwd));
              
 			 // 복호화해서 DTO에 담기
 	        usersDto.setEmail(aes.decrypt(users.getEmail()));
 	        usersDto.setMobile(aes.decrypt(users.getMobile()));
 	        
           } catch (Exception e) {   
              e.printStackTrace();
           }
        
     } catch(NoSuchElementException e) {
        // member.get() 에서 데이터가 존재하지 않는 경우
     } catch (Exception e) {
		e.printStackTrace();
	}
     return usersDto;
  } 

   
   // 아이디 중복 체크
   @Override
   public boolean isIdExists(String id) {
      return usersRepository.existsById(id);
   }


   // 이메일 중복 체크
   @Override
   public boolean isEmailExists(String email) {
	   try {
	        aes = new AES256(SecretMyKey.KEY);
	        String encryptedEmail = aes.encrypt(email);
	        return usersRepository.existsByEmail(encryptedEmail);
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	}
   

   // 회원가입
   @Override
   public void registerUser(Users user) {
      try {
         
         aes = new AES256(SecretMyKey.KEY);
         user.setMobile(aes.encrypt(user.getMobile()));
         user.setEmail(aes.encrypt(user.getEmail()));
         user.setPassword(Sha256.encrypt(user.getPassword()));
         
      } catch (Exception e) {
         e.printStackTrace();
      }
      usersRepository.save(user);  // JPA가 DB에 저장해줌
   }


   // 비밀번호 업데이트
   @Override
   public void updatePassword(String id, String newPassword) {
	   
       Users user = usersRepository.findById(id).orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));
       
       user.setPassword(Sha256.encrypt(newPassword));
      
       user.setPasswordChanged(LocalDateTime.now());   // 변경일 갱신
       user.setIsDormant(0);                           // 휴면 해제

       usersRepository.save(user);
   }

   //회원 수정하기
   @Override
   public UsersDTO updateUser(UsersDTO userDto) {
       Users user = usersRepository.findById(userDto.getId())
               .orElseThrow(() -> new RuntimeException("회원 정보를 찾을 수 없습니다."));

       try {
           aes = new AES256(SecretMyKey.KEY);
           user.setName(userDto.getName());
           user.setEmail(aes.encrypt(userDto.getEmail()));
           user.setMobile(aes.encrypt(userDto.getMobile()));

           if (userDto.getPassword() != null && !userDto.getPassword().isEmpty()) {
               user.setPassword(Sha256.encrypt(userDto.getPassword()));
               user.setPasswordChanged(LocalDateTime.now());
           }

           Users saved = usersRepository.save(user);

           // 복호화해서 DTO로 반환
           UsersDTO dto = saved.toDTO();
           dto.setEmail(aes.decrypt(saved.getEmail()));
           dto.setMobile(aes.decrypt(saved.getMobile()));
           return dto;

       } catch (Exception e) {
           e.printStackTrace();
           return null;
       }
   }
   
      
   //이메일 중복확인
   @Override
   public boolean isEmailDuplicated(String email) {
	   try {
	        aes = new AES256(SecretMyKey.KEY);
	        String encryptedEmail = aes.encrypt(email);
	        return usersRepository.existsByEmail(encryptedEmail);
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	}

   //회원탈퇴하기
   @Override
   public int delete(String id) {
      
      int n = 0;
      
      try {
         usersRepository.deleteById(id);
         
         n = 1;
      } catch (EmptyResultDataAccessException e) {
         
      }
         
      return n;
   }
   
   
   @Override
   public Users toEntity(UsersDTO userDto) {
       return Users.builder()
               .id(userDto.getId())
               .password(userDto.getPassword())
               .build();
   }

   @Override
   public void saveLoginHistory(LoginHistoryDTO loginHistoryDTO) {
           LoginHistory loginHistory = LoginHistory.builder()
                                  .lastLogin(loginHistoryDTO.getLastLogin())
                                  .ip(loginHistoryDTO.getIp())
                                  .users(loginHistoryDTO.getUsers())
                                  .build();

           historyRepository.save(loginHistory);
    }


    @Override
    public UsersDTO getIdFind(String name, String email) {
    	
    	String encryptEmail = "";
    	
    	try {
    		aes = new AES256(SecretMyKey.KEY);
    		encryptEmail = aes.encrypt(email.trim());
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
    	
        return usersRepository.findByNameAndEmail(name.trim(), encryptEmail)
        					  .map(Users::toDTO) // Users 엔티티에 toDTO() 있다고 가정
    					  	  .orElse(null);
    }
    
    // 유저 존재 여부 확인
    @Override
    public Users findByIdAndEmail(String id, String email) {
    	String encryptEmail = "";
    	try {
    		aes = new AES256(SecretMyKey.KEY);
    		encryptEmail = aes.encrypt(email.trim());
		} catch (UnsupportedEncodingException | GeneralSecurityException e) {
			e.printStackTrace();
		}
    	return usersRepository.findByIdAndEmail(id, encryptEmail);
    }

    //휴면처리하기 ( 비밀번호변경대상 )
    @Override
    public boolean updateDormantStatus(String id) {
         
       Users users = usersRepository.findById(id).orElse(null);
       //orElse는 객체꺼내기를 시도할때 값이 없으면 null 을 반환하라는 뜻 !
      
       LocalDateTime now = LocalDateTime.now();
      
       if(users.getPasswordChanged() == null || 
          users.getPasswordChanged().isBefore(now.minusYears(1))) {
            
          users.setIsDormant(1);
          usersRepository.save(users);
         
          return true;
         
       }
      
       return false;
    }


   
}
