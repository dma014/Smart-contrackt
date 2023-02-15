// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract digital_identidy {

    struct user_option {
        
        bool reg;
        bytes32 password;
        uint256 timeban;
        uint error_times;
    }
    mapping(string => user_option) user;

    function registration(string memory login, string memory password) public returns (string memory) {
	
        if (user[login].reg == false){

            user[login].password = sha256(abi.encodePacked(password));

            user[login].reg = true;

            return "Successful";
        }
        else{

            return "This login already exists.";
        }
    }
    function authorization(string memory login, string memory password) public returns (bool) {

        bytes32 hash_password;
        hash_password = sha256(abi.encodePacked(password));
        if (user[login].timeban > 0) {

            if (user[login].timeban > block.timestamp) {

                return false;

            }
            else {

                user[login].timeban = 0;
                user[login].error_times = 0;
            }
        }

        if (user[login].password == hash_password) {

            user[login].error_times = 0;
            
            return true;
        }

        else {

            if (user[login].error_times >= 3){

            user[login].timeban = block.timestamp + (2 * 60 * 60);

            return false;

            }

            user[login].error_times += 1;

            return false;
        }
    }

    function ban_check(string memory login) public view returns (uint256){

        if (user[login].timeban > 0){

            return (user[login].timeban - block.timestamp)/60;

        }

        else {

            return user[login].timeban;
        }
    }
}
