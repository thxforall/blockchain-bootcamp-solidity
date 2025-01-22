// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// 자동차와 관련된 어플리케이션을 만들면 됩니다.
// 1개의 smart contract가 자동차라고 생각하시고, 구조체를 활용하시면 편합니다.

// 아래의 기능들을 구현하세요.

// * 악셀 기능 - 속도를 10 올리는 기능, 악셀 기능을 이용할 때마다 연료가 20씩 줄어듬, 연료가 30이하면 더 이상 악셀을 이용할 수 없음, 속도가 70이상이면 악셀 기능은 더이상 못씀
// * 주유 기능 - 주유하는 기능, 주유를 하면 1eth를 지불해야하고 연료는 100이 됨
// * 브레이크 기능 - 속도를 10 줄이는 기능, 브레이크 기능을 이용할 때마다 연료가 10씩 줄어듬, 속도가 0이면 브레이크는 더이상 못씀
// * 시동 끄기 기능 - 시동을 끄는 기능, 속도가 0이 아니면 시동은 꺼질 수 없음
// * 시동 켜기 기능 - 시동을 켜는 기능, 시동을 키면 정지 상태로 설정됨
// --------------------------------------------------------
// * 충전식 기능 - 지불을 미리 해놓고 추후에 주유시 충전금액 차감

contract Q0110 {
    enum carStatus {
        STOP,
        DRIVING,
        OFF
    }

    struct Car {
        uint256 speed;
        uint256 fuel;
        carStatus status;
    }

    Car public car;

    function accelerate() public {
        require(
            car.status == carStatus.DRIVING && car.speed < 70 && car.fuel >= 20,
            "Car is not running"
        );
        car.speed += 10;
        car.fuel -= 20;

        if (car.status != carStatus.DRIVING) {
            car.status = carStatus.DRIVING;
        }
    }

    function Break() public {
        require(
            car.status == carStatus.DRIVING && car.speed > 0 && car.fuel >= 10,
            "Car is not running"
        );
        car.speed -= 10;
        car.fuel -= 10;

        if (car.speed == 0) {
            car.status = carStatus.STOP;
        }
    }

    function turnOff() public {
        require(
            car.status == carStatus.STOP && car.speed == 0,
            "Car is not stopped"
        );
        car.status = carStatus.OFF;
    }

    function turnOn() public {
        require(car.status == carStatus.OFF, "Car is not off");
        car.status = carStatus.DRIVING;
    }

    function fillFuel() public payable {
        require(
            msg.value == 1 ether &&
                address(msg.sender).balance >= 1 ether &&
                car.status == carStatus.OFF,
            "Not enough ETH"
        );

        car.fuel = 100;
    }

    receive() external payable {}
}
