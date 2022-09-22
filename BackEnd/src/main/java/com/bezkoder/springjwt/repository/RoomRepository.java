package com.bezkoder.springjwt.repository;

import com.bezkoder.springjwt.models.Room;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RoomRepository extends JpaRepository<Room, Long>, JpaSpecificationExecutor {
    //find by roomNumber
    Boolean existsByRoomNumber(int roomNumber);
    //List room by hotelId
    List<Room> findByHotelId(Long hotelId);

}
